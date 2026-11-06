"""Offline validation; requires Python + PyYAML, Helm 3 and HelmForge listmonk 1.2.3.
Usage: python scripts/validate_listmonk.py --chart /path/to/listmonk --helm /path/to/helm
No Azure or AKS calls. Fixture values are never deployment inputs.
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


def run(*args):
    result = subprocess.run(args, capture_output=True, text=True)
    if result.returncode:
        raise RuntimeError(result.stdout + result.stderr)
    return result.stdout


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--helm", default="helm")
    parser.add_argument("--chart", type=Path, required=True)
    args = parser.parse_args()
    assert yaml.safe_load((args.chart / "Chart.yaml").read_text(encoding="utf-8"))["version"] == "1.2.3"
    scratch = MODULE / ".terraform"
    scratch.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="listmonk-validation-", dir=scratch) as tmp:
        values_file = Path(tmp) / "values.yaml"
        for env in ("dev", "uat", "prod"):
            tfvars = (MODULE / f"env/itn-{env}/terraform.tfvars").read_text(encoding="utf-8")
            prefix = re.search(r'^dns_zone_internal_prefix\s*=\s*"([^"]+)"', tfvars, re.M)[1]
            host = f"listmonk.itn.{prefix}.cstar.pagopa.it"
            params = dict(replica_count="1", listmonk_ingress_hostname=host,
                          ingress_tls_secret_name=host.replace(".", "-"), postgres_db_name="listmonk",
                          postgres_db_host="postgres.test.invalid", postgres_db_port="5432",
                          postgres_db_username="listmonk", bootstrap_postgres_image="postgres:17-alpine")
            block = tfvars.split("listmonk_configuration = {", 1)[1].split("}", 1)[0]
            assert re.search(r'chart_version\s*=\s*"1.2.3"', block)
            for name in ("image_repository", "image_tag", "postgres_ssl_mode"):
                params[name] = re.search(rf'{name}\s*=\s*"([^"]*)"', block)[1]
            assert params["image_tag"] == "v6.2.0"
            values_file.write_text(Template((MODULE / "k8s/listmonk/values.yaml.tpl").read_text(encoding="utf-8")).substitute(params))
            run(args.helm, "lint", str(args.chart), "--strict", "--values", str(values_file))
            rendered = run(args.helm, "template", "listmonk", str(args.chart), "--namespace", "listmonk",
                           "--kube-version", "1.30.0", "--values", str(values_file))
            resources = [r for r in yaml.safe_load_all(rendered) if r]
            assert len(resources) == 4
            objects = {r["kind"]: r for r in resources}
            assert set(objects) == {"Deployment", "Service", "Ingress", "PersistentVolumeClaim"}
            assert all(r.get("apiVersion") and r["metadata"]["name"] for r in resources)
            pod = objects["Deployment"]["spec"]["template"]["spec"]
            assert objects["Deployment"]["spec"]["replicas"] == 1
            assert pod["automountServiceAccountToken"] is False
            assert [c["name"] for c in pod["initContainers"]] == ["wait-for-postgresql", "db-init"]
            init = pod["initContainers"][1]
            assert "--install --idempotent --yes" in init["command"][2] and "--upgrade --yes" in init["command"][2]
            app = pod["containers"][0]
            assert app["image"] == f"{params['image_repository']}:{params['image_tag']}"
            for container in (init, app):
                envs = {e["name"]: e for e in container["env"]}
                assert envs["LISTMONK_db__ssl_mode"]["value"] == "require"
                assert envs["LISTMONK_db__password"]["valueFrom"]["secretKeyRef"] == {"name": "listmonk-db-secret", "key": "db_password"}
                assert not any("SMTP" in name or "OIDC" in name for name in envs)
                if container is init:
                    assert envs["LISTMONK_ADMIN_PASSWORD"]["valueFrom"]["secretKeyRef"] == {"name": "listmonk-bootstrap", "key": "LISTMONK_ADMIN_PASSWORD"}
                else:
                    assert "LISTMONK_ADMIN_PASSWORD" not in envs
            assert all(p in app for p in ("startupProbe", "readinessProbe", "livenessProbe"))
            assert objects["Service"]["spec"]["type"] == "ClusterIP"
            ingress = objects["Ingress"]["spec"]
            assert ingress["ingressClassName"] == "nginx" and ingress["rules"][0]["host"] == host
            assert ingress["tls"][0]["secretName"] == host.replace(".", "-")
            assert objects["PersistentVolumeClaim"]["spec"]["accessModes"] == ["ReadWriteOnce"]
            print(f"PASS {env}: lint/render, four manifests, native bootstrap, secret references, private TLS Ingress")


if __name__ == "__main__":
    main()
