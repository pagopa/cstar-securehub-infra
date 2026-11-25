#!/usr/bin/env python3
"""
Runbook Name: SRTP - Recover failed GPD messages
Description:  Reads failed RTP messages from the Cosmos DB (Mongo API) collection
              rtp_failed_messages and, for each one:

  - verifies the payment notice against the pagoPA eCommerce payment-requests
    service (skipped for DELETE operations and UPDATE/PAID);
  - discards (deletes from Cosmos DB without sending) messages whose notice is
    no longer payable;
  - sends payable messages to the RTP API and deletes the Cosmos document for
    every response except retryable errors (5xx, 429, 401, 403), which are kept
    for a later retry together with requests that got no response at all;
  - leaves the document untouched when payability cannot be confirmed.

Source:       single-file copy of pagopa/rtp-internal
              recovery_rtp/sendGpdMessages (send_payloads.py, payment_verifier.py,
              env.py) at commit 5642788. Tests live there: port any logic fix to
              both places.

Differences from the original:
  - secrets are read from the SRTP Key Vault (cstar-<x>-itn-srtp-kv) with the
    ClouDO managed identity instead of a .env file; an environment variable with
    the same name (CLIENT_ID, ...) takes precedence, for local runs;
  - endpoints default per environment (--env), no .env needed;
  - secrets cannot be passed as CLI flags (run_args are visible in ClouDO);
  - pymongo is not in the worker image: it is pip-installed into a temp dir at
    start-up (needs egress to PyPI);
  - everything is printed to stdout, the only stream ClouDO keeps for a
    successful run.

Usage:
  python3 recover_gpd_messages.py --env dev [--limit 100] [--batch-size 20]

Local run (after `az login`, with read access to the SRTP Key Vault):
  python3 recover_gpd_messages.py --env dev --limit 10

Schema: pass the arguments through "run_args". It deletes Cosmos documents, so
        keep "require_approval": true.
"""

from __future__ import annotations

import argparse
import importlib
import os
import subprocess
import sys
import tempfile
import time
import uuid
from dataclasses import dataclass
from enum import Enum
from typing import Any, Iterable, Protocol, runtime_checkable

import requests


# ---------------------------------------------------------------------------
# Runtime dependencies
# ---------------------------------------------------------------------------

PYMONGO_REQUIREMENT = "pymongo==4.10.1"


def _ensure_pymongo() -> None:
    """Install pymongo into a temp dir when the interpreter does not have it."""
    try:
        importlib.import_module("pymongo")
        return
    except ImportError:
        pass

    target = tempfile.mkdtemp(prefix="recover_gpd_deps_")
    print(f"pymongo not available; installing {PYMONGO_REQUIREMENT} ...")
    subprocess.run(
        [
            sys.executable, "-m", "pip", "install",
            "--quiet", "--disable-pip-version-check", "--no-cache-dir",
            "--target", target, PYMONGO_REQUIREMENT,
        ],
        check=True,
        stdout=subprocess.DEVNULL,
    )
    sys.path.insert(0, target)
    importlib.invalidate_caches()


_ensure_pymongo()

import certifi  # noqa: E402  (installed with requests)
from pymongo import MongoClient  # noqa: E402
from pymongo.collection import Collection  # noqa: E402
from pymongo.errors import ConfigurationError  # noqa: E402


# ---------------------------------------------------------------------------
# Environments
# ---------------------------------------------------------------------------

VALID_ENVS: tuple[str, ...] = ("dev", "uat", "prod")

ENV_SHORT: dict[str, str] = {"dev": "d", "uat": "u", "prod": "p"}

# Hostname segment used by the cstar / pagoPA endpoints ("" for prod).
_HOST_SEGMENT: dict[str, str] = {"dev": "dev.", "uat": "uat.", "prod": ""}


def key_vault_name(env: str) -> str:
    return f"cstar-{ENV_SHORT[env]}-itn-srtp-kv"


def default_endpoints(env: str) -> dict[str, str]:
    seg = _HOST_SEGMENT[env]
    return {
        "token_url": (
            f"https://api-mcshared.{seg}cstar.pagopa.it"
            "/auth-itn/realms/srtp/protocol/openid-connect/token"
        ),
        "api_url": f"https://api-rtp.{seg}cstar.pagopa.it/rtp/gpd/message",
        "payment_requests_url": (
            f"https://api.{seg}platform.pagopa.it"
            "/ecommerce/payment-requests-service/v1"
        ),
    }


# Config field -> (environment variable, Key Vault secret name)
SECRETS: dict[str, tuple[str, str]] = {
    "client_id": ("CLIENT_ID", "rtp-recovery-client-id"),
    "client_secret": ("CLIENT_SECRET", "rtp-recovery-client-secret"),
    "payment_requests_api_key": (
        "PAYMENT_REQUESTS_API_KEY",
        "rtp-recovery-payment-requests-api-key",
    ),
    "cosmos_connection_string": (
        "COSMOS_CONNECTION_STRING",
        "cosmosdb-account-rtp-primary-connection-string",
    ),
}


def load_secrets(env: str) -> dict[str, str]:
    """Read every secret from its env var, falling back to the SRTP Key Vault."""
    values: dict[str, str] = {}
    missing_from_env: dict[str, str] = {}
    for field, (env_var, secret_name) in SECRETS.items():
        value = os.environ.get(env_var)
        if value:
            values[field] = value
        else:
            missing_from_env[field] = secret_name

    if not missing_from_env:
        return values

    from azure.identity import DefaultAzureCredential
    from azure.keyvault.secrets import SecretClient

    vault = key_vault_name(env)
    print(f"Reading {len(missing_from_env)} secret(s) from Key Vault {vault}.")
    client = SecretClient(
        vault_url=f"https://{vault}.vault.azure.net",
        credential=DefaultAzureCredential(),
    )
    for field, secret_name in missing_from_env.items():
        values[field] = client.get_secret(secret_name).value or ""
    return values


# ---------------------------------------------------------------------------
# Payment verification (from payment_verifier.py)
# ---------------------------------------------------------------------------

API_KEY_HEADER: str = "Ocp-Apim-Subscription-Key"
PAYMENT_REQUESTS_PATH: str = "/payment-requests/"
DEFAULT_TIMEOUT_SECONDS: int = 30

AUTH_ERROR_STATUSES: frozenset[int] = frozenset({401, 403})

# faultCodeCategory values that mean the notice can no longer be paid.
# Keyed by HTTP status so a category is only trusted on the status the
# OpenAPI contract documents for it.
NOT_PAYABLE_CATEGORIES: dict[int, frozenset[str]] = {
    409: frozenset({"PAYMENT_DUPLICATED", "PAYMENT_EXPIRED", "PAYMENT_CANCELED"}),
    404: frozenset({"PAYMENT_UNKNOWN"}),
}

_BODY_EXCERPT_CHARS: int = 300


class PaymentStatus(str, Enum):
    PAYABLE = "PAYABLE"
    NOT_PAYABLE = "NOT_PAYABLE"
    UNCONFIRMED = "UNCONFIRMED"


@dataclass(frozen=True)
class VerificationResult:
    status: PaymentStatus
    reason: str

    @property
    def is_definitive(self) -> bool:
        return self.status is not PaymentStatus.UNCONFIRMED


class PaymentVerifierAuthError(RuntimeError):
    """The payment-requests service rejected the subscription key.

    Every subsequent call would fail the same way, so callers should stop the
    run instead of treating each notice as unconfirmed.
    """


@runtime_checkable
class PaymentVerifier(Protocol):
    """Interface for checking whether a payment notice is still payable."""

    def verify(self, notice_code: str, ec_tax_code: str) -> VerificationResult: ...

    def __enter__(self) -> PaymentVerifier: ...
    def __exit__(self, *args: object) -> None: ...


class PaymentRequestsVerifier:
    """Verifies payability via the eCommerce payment-requests REST API.

        GET {base_url}/payment-requests/{ec_tax_code}{notice_code}
        Header: Ocp-Apim-Subscription-Key: <key>
    """

    def __init__(
        self,
        *,
        base_url: str,
        api_key: str,
        timeout_seconds: int = DEFAULT_TIMEOUT_SECONDS,
        session: requests.Session | None = None,
    ) -> None:
        self._base_url = base_url.rstrip("/")
        self._api_key = api_key
        self._timeout = timeout_seconds
        self._session = session
        self._owns_session = session is None
        self._cache: dict[tuple[str, str], VerificationResult] = {}

    def __enter__(self) -> PaymentRequestsVerifier:
        if self._session is None:
            self._session = requests.Session()
        self._session.headers.update(
            {API_KEY_HEADER: self._api_key, "Accept": "application/json"}
        )
        return self

    def __exit__(self, *args: object) -> None:
        if self._owns_session and self._session is not None:
            self._session.close()
            self._session = None

    def verify(self, notice_code: str, ec_tax_code: str) -> VerificationResult:
        """Return whether *notice_code* issued by *ec_tax_code* is payable.

        Definitive results (PAYABLE / NOT_PAYABLE) are cached for the lifetime
        of the context manager; UNCONFIRMED results are not, so a transient
        failure is retried for the next document with the same notice.
        """
        if self._session is None:
            raise RuntimeError(
                "PaymentRequestsVerifier must be used as a context manager."
            )

        key = (notice_code, ec_tax_code)
        cached = self._cache.get(key)
        if cached is not None:
            print(f"  Cache hit for notice {notice_code} / {ec_tax_code}: {cached.status.value}.")
            return cached

        result = self._call(notice_code, ec_tax_code)
        print(f"  -> {result.status.value}: {result.reason}")
        if result.is_definitive:
            self._cache[key] = result
        return result

    def build_url(self, notice_code: str, ec_tax_code: str) -> str:
        return f"{self._base_url}{PAYMENT_REQUESTS_PATH}{ec_tax_code}{notice_code}"

    def _call(self, notice_code: str, ec_tax_code: str) -> VerificationResult:
        assert self._session is not None
        url = self.build_url(notice_code, ec_tax_code)
        print(f"  Verifying notice {notice_code} / {ec_tax_code} ...")

        try:
            response = self._session.get(url, timeout=self._timeout)
        except requests.RequestException as exc:
            return VerificationResult(
                PaymentStatus.UNCONFIRMED, f"request failed: {exc.__class__.__name__}: {exc}"
            )

        return classify_response(response.status_code, _safe_json(response), response.text)


def classify_response(
    status_code: int,
    body: Any,
    raw_text: str = "",
) -> VerificationResult:
    """Map a payment-requests HTTP response to a VerificationResult."""
    if status_code == 200:
        return VerificationResult(PaymentStatus.PAYABLE, "HTTP 200")

    if status_code in AUTH_ERROR_STATUSES:
        raise PaymentVerifierAuthError(
            f"payment-requests service returned HTTP {status_code}; "
            "check the payment-requests API key and URL."
        )

    category = body.get("faultCodeCategory") if isinstance(body, dict) else None
    detail = body.get("faultCodeDetail") if isinstance(body, dict) else None
    fault = f"{category}/{detail}" if category else "no fault code"

    if category in NOT_PAYABLE_CATEGORIES.get(status_code, frozenset()):
        return VerificationResult(PaymentStatus.NOT_PAYABLE, f"HTTP {status_code} {fault}")

    excerpt = "" if category else f" body={raw_text[:_BODY_EXCERPT_CHARS]!r}"
    return VerificationResult(
        PaymentStatus.UNCONFIRMED, f"HTTP {status_code} {fault}{excerpt}"
    )


def _safe_json(response: requests.Response) -> Any:
    try:
        return response.json()
    except ValueError:
        return None


# ---------------------------------------------------------------------------
# Configuration (from send_payloads.py)
# ---------------------------------------------------------------------------

_REQUIRED = "__REQUIRED__"
NUMBER_LONG_FIELD = "$numberLong"
DELETE_OPERATION = "DELETE"
RETRYABLE_4XX_STATUSES: frozenset[int] = frozenset({401, 403, 429})
DELETE_PAYLOAD_FIELDS: tuple[str, ...] = (
    "id",
    "operation",
    "timestamp",
    "iuv",
    "subject",
    "description",
    "ec_tax_code",
    "debtor_tax_code",
    "nav",
    "due_date",
    "amount",
    "status",
    "psp_code",
    "psp_tax_code",
)


@dataclass
class Config:
    """All tuneable parameters for the failed-message recovery pipeline."""

    # --- Secrets (required, from Key Vault) ---
    client_id: str = _REQUIRED
    client_secret: str = _REQUIRED
    payment_requests_api_key: str = _REQUIRED
    cosmos_connection_string: str = _REQUIRED

    # --- Cosmos DB ---
    cosmos_database: str = "rtp"
    cosmos_collection: str = "rtp_failed_messages"

    # --- Endpoints (defaulted per environment) ---
    token_url: str = _REQUIRED
    api_url: str = _REQUIRED
    payment_requests_url: str = _REQUIRED

    # --- HTTP ---
    api_version_header: str = "v1"

    # --- Processing ---
    batch_size: int = 20
    batch_interval_seconds: int = 1
    limit: int = 0
    payment_requests_timeout_seconds: int = DEFAULT_TIMEOUT_SECONDS

    def validate(self) -> None:
        missing = [
            name for name, value in self.__dict__.items() if value in (_REQUIRED, "")
            and name != "cosmos_database"
        ]
        if missing:
            raise ValueError(
                "The following required configuration values are not set: "
                + ", ".join(missing).upper()
            )
        if self.batch_size < 1:
            raise ValueError("BATCH_SIZE must be greater than zero.")
        if self.batch_interval_seconds < 0:
            raise ValueError("BATCH_INTERVAL_SECONDS cannot be negative.")
        if self.payment_requests_timeout_seconds < 1:
            raise ValueError("PAYMENT_REQUESTS_TIMEOUT_SECONDS must be greater than zero.")


# ---------------------------------------------------------------------------
# Token cache
# ---------------------------------------------------------------------------

TOKEN_EXPIRY_MARGIN_S: int = 30
_token_cache: dict[tuple[str, str], tuple[str, float]] = {}


def _get_cached_token(cfg: Config) -> str | None:
    key = (cfg.token_url, cfg.client_id)
    entry = _token_cache.get(key)
    if entry is None:
        return None
    token, expiry = entry
    if time.monotonic() < expiry:
        return token
    del _token_cache[key]
    return None


def _cache_token(cfg: Config, token: str, expires_in: int) -> None:
    key = (cfg.token_url, cfg.client_id)
    expiry = time.monotonic() + max(0, expires_in - TOKEN_EXPIRY_MARGIN_S)
    _token_cache[key] = (token, expiry)


def get_token(cfg: Config) -> str:
    """Obtain a client-credentials bearer token, refreshing before expiry."""
    cached = _get_cached_token(cfg)
    if cached is not None:
        print("Using cached access token.")
        return cached

    print("Fetching access token...")
    response = requests.post(
        cfg.token_url,
        data={
            "grant_type": "client_credentials",
            "client_id": cfg.client_id,
            "client_secret": cfg.client_secret,
        },
        headers={"Content-Type": "application/x-www-form-urlencoded"},
        timeout=30,
    )
    response.raise_for_status()
    data = response.json()
    token = data["access_token"]
    expires_in = int(data.get("expires_in", TOKEN_EXPIRY_MARGIN_S * 2))
    _cache_token(cfg, token, expires_in)
    return token


# ---------------------------------------------------------------------------
# Cosmos DB
# ---------------------------------------------------------------------------

def get_failed_messages_collection(cfg: Config) -> Collection:
    client: MongoClient[Any] = MongoClient(
        cfg.cosmos_connection_string,
        tlsCAFile=certifi.where(),
    )
    if cfg.cosmos_database:
        database = client[cfg.cosmos_database]
    else:
        try:
            database = client.get_default_database()
        except ConfigurationError as exc:
            raise ValueError(
                "--cosmos-database is required when the connection string does "
                "not include a default database."
            ) from exc
    print(
        "Using Cosmos DB "
        f"database '{database.name}', collection '{cfg.cosmos_collection}'."
    )
    return database[cfg.cosmos_collection]


def load_failed_documents(collection: Collection, limit: int = 0) -> list[dict[str, Any]]:
    """Load failed-message documents ordered by notice number and timestamp."""
    cursor = collection.find({})
    if limit > 0:
        cursor = cursor.limit(limit)

    docs = list(cursor)
    docs.sort(key=_document_sort_key)
    return docs


def _document_sort_key(doc: dict[str, Any]) -> tuple[str, int, str]:
    message = doc.get("message") or {}
    nav = "" if message.get("nav") is None else str(message.get("nav"))
    timestamp = _to_int(message.get("timestamp"), default=0)
    return nav, timestamp, str(doc.get("_id", ""))


def delete_failed_document(collection: Collection, doc: dict[str, Any]) -> bool:
    result = collection.delete_one({"_id": doc["_id"]})
    return result.deleted_count == 1


# ---------------------------------------------------------------------------
# Payload handling
# ---------------------------------------------------------------------------

def extract_payload(doc: dict[str, Any]) -> dict[str, Any]:
    message = doc.get("message")
    if not isinstance(message, dict):
        raise ValueError(f"Document {doc.get('_id')} has no message object.")

    payload = {key: _normalise_bson_export_value(value) for key, value in message.items()}
    if "_id" in payload:
        payload["id"] = payload.pop("_id")
    if _payload_operation(payload) == DELETE_OPERATION:
        payload = _normalise_delete_payload(payload)
    return payload


def _payload_operation(payload: dict[str, Any]) -> str:
    return str(payload.get("operation", "")).upper()


def _normalise_delete_payload(payload: dict[str, Any]) -> dict[str, Any]:
    return {
        field: payload.get(field) if field in {"id", "operation", "timestamp"} else None
        for field in DELETE_PAYLOAD_FIELDS
    }


def _normalise_bson_export_value(value: Any) -> Any:
    if isinstance(value, dict):
        if NUMBER_LONG_FIELD in value:
            return _to_int(value[NUMBER_LONG_FIELD])
        if "$oid" in value:
            return value["$oid"]
        return {k: _normalise_bson_export_value(v) for k, v in value.items()}
    if isinstance(value, list):
        return [_normalise_bson_export_value(item) for item in value]
    return value


def _to_int(value: Any, default: int | None = None) -> int:
    if value is None:
        if default is not None:
            return default
        raise ValueError("Cannot convert None to int.")
    if isinstance(value, dict):
        value = value.get(NUMBER_LONG_FIELD)
    try:
        return int(value)
    except (TypeError, ValueError):
        if default is not None:
            return default
        raise


class Decision(str, Enum):
    SEND = "SEND"          # send to RTP
    DISCARD = "DISCARD"    # notice no longer payable: delete from Cosmos, do not send
    LEAVE = "LEAVE"        # cannot decide now: keep in Cosmos for a later run


_VERIFICATION_DECISIONS: dict[PaymentStatus, Decision] = {
    PaymentStatus.PAYABLE: Decision.SEND,
    PaymentStatus.NOT_PAYABLE: Decision.DISCARD,
    PaymentStatus.UNCONFIRMED: Decision.LEAVE,
}


def decide(payload: dict[str, Any], verifier: PaymentVerifier) -> Decision:
    operation = _payload_operation(payload)
    status = str(payload.get("status", "")).upper()

    if operation == DELETE_OPERATION:
        print("  -> DELETE operation; skipping payment verification.")
        return Decision.SEND
    if operation == "UPDATE" and status == "PAID":
        print("  -> UPDATE with status PAID; sending without payment verification.")
        return Decision.SEND

    notice_code = payload.get("nav")
    ec_tax_code = payload.get("ec_tax_code")
    if not notice_code or not ec_tax_code:
        print("  -> Missing nav/ec_tax_code; leaving document unprocessed.")
        return Decision.LEAVE

    result = verifier.verify(str(notice_code), str(ec_tax_code))
    return _VERIFICATION_DECISIONS[result.status]


def send_payload(cfg: Config, payload: dict[str, Any]) -> requests.Response:
    token = get_token(cfg)
    headers = {
        "Content-Type": "application/json",
        "Version": cfg.api_version_header,
        "Authorization": f"Bearer {token}",
        "RequestId": str(uuid.uuid4()),
        "Idempotency-Key": str(uuid.uuid4()),
    }
    return requests.post(cfg.api_url, json=payload, headers=headers, timeout=30)


def _iter_batches(items: list[dict[str, Any]], size: int) -> Iterable[list[dict[str, Any]]]:
    for start in range(0, len(items), size):
        yield items[start : start + size]


@dataclass
class ProcessingResult:
    sent: int = 0
    deleted: int = 0
    discarded: int = 0
    skipped: int = 0

    def add(self, other: "ProcessingResult") -> None:
        self.sent += other.sent
        self.deleted += other.deleted
        self.discarded += other.discarded
        self.skipped += other.skipped


def _delete_if_processed(
    collection: Collection,
    doc: dict[str, Any],
    response: requests.Response,
) -> bool:
    if is_retryable_error(response.status_code):
        print("      Retryable error; left in Cosmos DB for a later retry.")
        return False

    if delete_failed_document(collection, doc):
        print("      Deleted from Cosmos DB.")
        return True

    print("      Delete skipped: document was not found.")
    return False


def is_retryable_error(status_code: int) -> bool:
    """5xx, 429, 401 and 403 are retried later; every other RTP response is final."""
    return status_code >= 500 or status_code in RETRYABLE_4XX_STATUSES


def _process_document(
    cfg: Config,
    collection: Collection,
    verifier: PaymentVerifier,
    doc: dict[str, Any],
    index: int,
    batch_size: int,
) -> ProcessingResult:
    doc_id = doc.get("_id")
    try:
        payload = extract_payload(doc)
        notice = payload.get("nav")
        print(f"  [{index}/{batch_size}] Document {doc_id} notice {notice}")

        decision = decide(payload, verifier)
        if decision is Decision.LEAVE:
            print("      Left in Cosmos DB for a later retry.")
            return ProcessingResult(skipped=1)
        if decision is Decision.DISCARD:
            return _discard(collection, doc)

        response = send_payload(cfg, payload)
        print(f"      Status: {response.status_code}")
        print(f"      Body: {response.text}")

        deleted = int(_delete_if_processed(collection, doc, response))
        return ProcessingResult(sent=1, deleted=deleted)
    except PaymentVerifierAuthError:
        raise
    except Exception as exc:
        print(f"      Error processing document {doc_id}: {exc}")
        return ProcessingResult()


def _discard(collection: Collection, doc: dict[str, Any]) -> ProcessingResult:
    if delete_failed_document(collection, doc):
        print("      Notice not payable; discarded (deleted from Cosmos DB, not sent).")
        return ProcessingResult(discarded=1)
    print("      Notice not payable; discard skipped: document was not found.")
    return ProcessingResult()


def _sleep_until_next_batch(cfg: Config, batch_started: float) -> None:
    elapsed = time.monotonic() - batch_started
    if cfg.batch_interval_seconds and elapsed < cfg.batch_interval_seconds:
        time.sleep(cfg.batch_interval_seconds - elapsed)


# ---------------------------------------------------------------------------
# Orchestrator
# ---------------------------------------------------------------------------

def send_payloads(
    cfg: Config,
    verifier: PaymentVerifier | None = None,
    collection: Collection | None = None,
) -> None:
    """Recover failed messages from Cosmos DB and delete only processed docs."""
    if verifier is None:
        verifier_cm: PaymentVerifier = PaymentRequestsVerifier(
            base_url=cfg.payment_requests_url,
            api_key=cfg.payment_requests_api_key,
            timeout_seconds=cfg.payment_requests_timeout_seconds,
        )
    else:
        verifier_cm = verifier

    collection = collection or get_failed_messages_collection(cfg)
    docs = load_failed_documents(collection, cfg.limit)
    print(f"Found {len(docs)} failed message document(s) to process.\n")
    if not docs:
        print("No Cosmos documents found; verification and RTP send were not executed.")
        return

    totals = ProcessingResult()

    with verifier_cm as active_verifier:
        for batch_index, batch in enumerate(_iter_batches(docs, cfg.batch_size), 1):
            batch_started = time.monotonic()
            print(f"Batch {batch_index}: processing {len(batch)} document(s).")

            for idx, doc in enumerate(batch, 1):
                result = _process_document(cfg, collection, active_verifier, doc, idx, len(batch))
                totals.add(result)

            _sleep_until_next_batch(cfg, batch_started)

    print(
        "\nDone. "
        f"Sent attempts: {totals.sent}. Deleted after send: {totals.deleted}. "
        f"Discarded (not payable): {totals.discarded}. "
        f"Left for retry: {totals.skipped}. "
        f"Remaining: {len(docs) - totals.deleted - totals.discarded}."
    )


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Recover RTP failed messages directly from Cosmos DB.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )

    parser.add_argument(
        "--env",
        required=True,
        choices=VALID_ENVS,
        help="Target environment: selects the SRTP Key Vault and the default endpoints.",
    )

    cosmos = parser.add_argument_group("Cosmos DB")
    cosmos.add_argument("--cosmos-database", default=None, help="Database name (default: rtp).")
    cosmos.add_argument("--cosmos-collection", default=None, help="Failed-message collection name.")

    ep = parser.add_argument_group("Endpoints (default: derived from --env)")
    ep.add_argument("--token-url", default=None, help="OAuth2 token endpoint.")
    ep.add_argument("--api-url", default=None, help="RTP API endpoint.")
    ep.add_argument(
        "--payment-requests-url",
        default=None,
        help="eCommerce payment-requests service base URL (without /payment-requests).",
    )

    beh = parser.add_argument_group("Behaviour")
    beh.add_argument("--api-version", default=None, help="Version request header.")
    beh.add_argument("--batch-size", type=int, default=None, help="Documents per batch.")
    beh.add_argument(
        "--batch-interval-seconds",
        type=int,
        default=None,
        help="Minimum seconds between batch starts.",
    )
    beh.add_argument("--limit", type=int, default=None, help="Maximum documents to fetch.")
    beh.add_argument(
        "--payment-requests-timeout-seconds",
        type=int,
        default=None,
        help="Timeout for each payment verification call.",
    )

    return parser


def main(argv: list[str] | None = None) -> None:
    args = build_parser().parse_args(argv)
    print(f"Target environment: {args.env}")

    try:
        cfg = Config(**default_endpoints(args.env), **load_secrets(args.env))
    except Exception as exc:
        print(f"Cannot load secrets from {key_vault_name(args.env)}: {exc}")
        sys.exit(1)

    cli_overrides = {
        "cosmos_database": args.cosmos_database,
        "cosmos_collection": args.cosmos_collection,
        "token_url": args.token_url,
        "api_url": args.api_url,
        "payment_requests_url": args.payment_requests_url,
        "payment_requests_timeout_seconds": args.payment_requests_timeout_seconds,
        "api_version_header": args.api_version,
        "batch_size": args.batch_size,
        "batch_interval_seconds": args.batch_interval_seconds,
        "limit": args.limit,
    }
    for attr, value in cli_overrides.items():
        if value is not None:
            setattr(cfg, attr, value)

    try:
        cfg.validate()
        send_payloads(cfg)
    except ValueError as exc:
        print(f"Configuration error: {exc}")
        sys.exit(1)
    except PaymentVerifierAuthError as exc:
        print(f"Payment verification aborted: {exc}")
        sys.exit(1)


if __name__ == "__main__":
    main()
