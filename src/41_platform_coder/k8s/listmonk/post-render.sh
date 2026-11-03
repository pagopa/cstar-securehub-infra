#!/usr/bin/env bash
set -euo pipefail

if ! command -v kubectl >/dev/null 2>&1; then
  echo "Listmonk Helm post-rendering requires kubectl with Kustomize support." >&2
  exit 1
fi

workdir=$(mktemp -d)
trap 'rm -f "$workdir/resources.yaml" "$workdir/kustomization.yaml"; rmdir "$workdir"' EXIT

cat > "$workdir/resources.yaml"
cat > "$workdir/kustomization.yaml" <<'YAML'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - resources.yaml
patches:
  - target:
      group: apps
      version: v1
      kind: Deployment
      name: listmonk
    patch: |-
      - op: add
        path: /spec/strategy
        value:
          type: Recreate
YAML

kubectl kustomize "$workdir"
