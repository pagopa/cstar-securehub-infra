"""Offline render checks. Requires Python + PyYAML and Helm 3; never contacts AKS.

Usage: python scripts/validate_listmonk.py --helm /path/to/helm
Optional: --upstream /path/to/extracted/listmonk-1.2.3 for migration comparison.
The generated values are test fixtures, never deployment inputs.
"""

import argparse
import re
import subprocess
import tempfile
from pathlib import Path
from string import Template

import yaml


ROOT = Path(__file__).resolve().parents[1]
MODULE = ROOT / "src/41_platform_coder"
CHART = MODULE / "k8s/listmonk/chart"


def run(*args, success=True):
    result = subprocess.run(args, capture_output=True, text=True, check=False)
    if success and result.returncode:
        raise RuntimeError(result.stdout + result.stderr)
    return result


def render(helm, chart, values):
    rendered = run(helm, "template", "listmonk", str(chart), "--namespace", "listmonk",
                   "--kube-version", "1.30.0", "--values", str(values)).stdout
    resources = [r for r in yaml.safe_load_all(rendered) if r]
    assert len(resources) == 4, "Only Deployment, Service, Ingress and PVC are expected"
    return {r["kind"]: r for r in resources}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--helm", default="helm")
    parser.add_argument("--upstream", type=Path)
    args = parser.parse_args()
    scratch = (MODULE / ".terraform").resolve()
    scratch.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="listmonk-validation-", dir=scratch) as tmp:
        assert Path(tmp).resolve().is_relative_to(scratch)
        values_file = Path(tmp) / "values.yaml"
        for env in ("dev", "uat", "prod"):
            tfvars = (MODULE / f"env/itn-{env}/terraform.tfvars").read_text()
            def value(name):
                return re.search(rf'^\s*{name}\s*=\s*"([^"]*)"', tfvars, re.M)[1]
            host = f"listmonk.itn.{value('dns_zone_internal_prefix')}.cstar.pagopa.it"
            params = dict(
                replica_count="1", listmonk_ingress_hostname=host,
                ingress_tls_secret_name=host.replace(".", "-"),
                postgres_db_name="listmonk", postgres_db_host="postgres.test.invalid",
                postgres_db_port="5432", postgres_db_username="listmonk",
                postgres_ssl_mode="require", bootstrap_checksum="offline-test",
                bootstrap_postgres_image="postgres:17-alpine",
                smtp_enabled="false", smtp_credentials_secret='""',
            )
            # Match the Listmonk block, rather than the earlier Keycloak image fields.
            block = tfvars.split("listmonk_configuration = {", 1)[1].split("}", 1)[0]
            for name in ("image_repository", "image_tag", "postgres_ssl_mode"):
                params[name] = re.search(rf'{name}\s*=\s*"([^"]*)"', block)[1]
            content = Template((MODULE / "k8s/listmonk/values.yaml.tpl").read_text()).substitute(params)
            values_file.write_text(content)
            run(args.helm, "lint", str(CHART), "--strict", "--values", str(values_file))
            resources = render(args.helm, CHART, values_file)
            assert set(resources) == {"Deployment", "Service", "Ingress", "PersistentVolumeClaim"}
            dep = resources["Deployment"]
            assert dep["metadata"]["name"] == "listmonk"
            assert dep["spec"]["strategy"] == {"type": "Recreate"}
            assert dep["spec"]["replicas"] == 1
            pod = dep["spec"]["template"]["spec"]
            assert [c["name"] for c in pod["initContainers"]] == ["wait-for-postgresql", "db-init", "settings"]
            assert pod["automountServiceAccountToken"] is False
            app = pod["containers"][0]
            assert app["image"] == f"{params['image_repository']}:{params['image_tag']}"
            assert app["command"] == ["./listmonk", "--config="]
            assert {e["name"] for e in app["env"]}.isdisjoint({"LISTMONK_ADMIN_PASSWORD", "LISTMONK_OIDC_CONFIG", "LISTMONK_SMTP_USERNAME", "LISTMONK_SMTP_PASSWORD"})
            settings = pod["initContainers"][2]
            assert not any(e["name"] in {"LISTMONK_SMTP_USERNAME", "LISTMONK_SMTP_PASSWORD"} for e in settings["env"])
            assert next(e for e in settings["env"] if e["name"] == "LISTMONK_SMTP_CONFIG")["valueFrom"]["secretKeyRef"]["key"] == "LISTMONK_SMTP_CONFIG"
            assert all(probe in app for probe in ("startupProbe", "readinessProbe", "livenessProbe"))
            assert all(c.get("resources", {}).get("limits") for c in pod["initContainers"] + pod["containers"])
            assert resources["Service"]["spec"]["type"] == "ClusterIP"
            ingress = resources["Ingress"]["spec"]
            assert ingress["ingressClassName"] == "nginx"
            assert ingress["rules"][0]["host"] == host
            assert ingress["tls"][0]["secretName"] == host.replace(".", "-")
            pvc = resources["PersistentVolumeClaim"]
            assert pvc["metadata"]["name"] == "listmonk-uploads"
            assert pvc["metadata"]["annotations"]["argocd.argoproj.io/sync-options"] == "Prune=false,Delete=false"
            assert pvc["spec"]["accessModes"] == ["ReadWriteOnce"]
            if args.upstream:
                original = render(args.helm, args.upstream, values_file)
                for kind in ("Service", "Ingress", "PersistentVolumeClaim"):
                    assert resources[kind]["metadata"]["name"] == original[kind]["metadata"]["name"]
                    assert resources[kind]["spec"] == original[kind]["spec"], kind
                assert dep["spec"]["selector"] == original["Deployment"]["spec"]["selector"]
            # Guardrails must reject unsafe overrides, before anything reaches the cluster.
            for setting in ("replicaCount=2", "postgresql.enabled=true", "database.external.existingSecret=", "listmonk.admin.existingSecret=", "bootstrap.smtp.enabled=true"):
                assert run(args.helm, "template", "listmonk", str(CHART), "--values",
                           str(values_file), "--set", setting, success=False).returncode != 0
            # Test-only Secret name: never applied. Only the settings init receives credential refs.
            enabled_values = yaml.safe_load(content)
            enabled_values["bootstrap"]["smtp"] = {"enabled": True, "credentialsSecretName": "smtp-test-fixture"}
            values_file.write_text(yaml.safe_dump(enabled_values))
            enabled_resources = render(args.helm, CHART, values_file)
            enabled_pod = enabled_resources["Deployment"]["spec"]["template"]["spec"]
            for name, key in (("LISTMONK_SMTP_USERNAME", "username"), ("LISTMONK_SMTP_PASSWORD", "password")):
                env_entry = next(e for e in enabled_pod["initContainers"][2]["env"] if e["name"] == name)
                assert env_entry == {"name": name, "valueFrom": {"secretKeyRef": {"name": "smtp-test-fixture", "key": key}}}
                assert all(e["name"] != name for e in enabled_pod["containers"][0]["env"])
            assert set(enabled_resources) == set(resources)
            print(f"PASS {env}: lint, render, ownership, ordered initialization, TLS, PVC, SMTP secret isolation, safety guards")


if __name__ == "__main__":
    main()
