import json
import os
import sys
import time
from email.utils import formataddr
from http.cookiejar import CookieJar
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode
from urllib.request import (
    HTTPCookieProcessor,
    HTTPRedirectHandler,
    ProxyHandler,
    Request,
    build_opener,
)


class NoRedirects(HTTPRedirectHandler):
    def redirect_request(self, *args, **kwargs):
        return None


def setting(name):
    value = os.environ.get(name)
    if not value:
        raise RuntimeError(f"Missing required setting {name}")
    return value


def configure():
    url = setting("LISTMONK_URL")
    if not url.startswith("https://"):
        raise RuntimeError("Listmonk URL must use HTTPS")

    cookies = CookieJar()
    opener = build_opener(ProxyHandler({}), HTTPCookieProcessor(cookies), NoRedirects())

    def request(method, path, data=None, content_type="application/json", expected=200):
        # A settings write can briefly restart Listmonk behind the ingress.
        for attempt in range(8):
            try:
                req = Request(url + path, data, {"Content-Type": content_type}, method=method)
                with opener.open(req, timeout=5) as response:
                    if response.status != expected:
                        raise RuntimeError(f"{method} {path}: unexpected HTTP {response.status}")
                    return response.read()
            except HTTPError as exc:
                exc.close()
                if exc.code == expected == 302:
                    return b""
                if exc.code not in (502, 503, 504) or attempt == 7:
                    raise RuntimeError(f"{method} {path}: HTTP {exc.code}") from None
            except (URLError, TimeoutError, ConnectionError) as exc:
                if attempt == 7:
                    raise RuntimeError(f"{method} {path}: {exc}") from None
            time.sleep(2)

    sender = setting("SMTP_FROM_ADDRESS")
    from_email = formataddr((setting("SMTP_FROM_NAME"), sender))
    smtp = [{
        "enabled": True,
        "host": setting("SMTP_HOST"),
        "port": int(setting("SMTP_PORT")),
        "auth_protocol": "login",
        "username": setting("SMTP_USERNAME"),
        "password": setting("SMTP_PASSWORD"),
        "tls_type": setting("SMTP_TLS_TYPE"),
        "tls_skip_verify": False,
        "from_addresses": [sender],
        "max_conns": 10,
        "idle_timeout": "15s",
        "wait_timeout": "5s",
        "max_msg_retries": 2,
        "msg_retry_delay": "10ms",
    }]
    request(
        "POST",
        "/admin/login",
        urlencode({
            "username": setting("LISTMONK_ADMIN_USERNAME"),
            "password": setting("LISTMONK_ADMIN_PASSWORD"),
            "next": "/admin",
        }).encode(),
        "application/x-www-form-urlencoded",
        expected=302,
    )
    if not any(cookie.name == "session" for cookie in cookies):
        raise RuntimeError("Listmonk login did not establish a session")

    def put(key, value):
        result = json.loads(request("PUT", f"/api/settings/{key}", json.dumps(value).encode()))
        if result.get("data") == {"needs_restart": True}:
            print("Settings saved; reload deferred while campaigns are running.", flush=True)
        elif result.get("data") is not True:
            raise RuntimeError(f"Listmonk did not confirm the {key} update")

    try:
        current = json.loads(request("GET", "/api/settings"))["data"]
        if current.get("app.from_email") != from_email:
            put("app.from_email", from_email)
        # GET masks the SMTP password, so reapply to pick up rotations.
        put("smtp", smtp)
    finally:
        request("POST", "/api/logout", b"")
    print("Listmonk SMTP settings saved.", flush=True)


if __name__ == "__main__":
    try:
        configure()
    except (RuntimeError, ValueError, KeyError) as exc:
        sys.exit(f"SMTP configuration failed: {exc}")
