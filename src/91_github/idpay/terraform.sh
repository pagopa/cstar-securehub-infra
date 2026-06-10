#!/bin/bash
echo "ℹ️ Running terraform.sh wrapper..."

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../../.." && pwd)"

env=$2
if [ -n "$env" ]; then
  # shellcheck source=/dev/null
  source "./env/$env/backend.ini"
  if [ -z "$(command -v az)" ]; then
    echo "❌ az not found, cannot proceed"
    exit 1
  fi
  export TF_VAR_subscription_id_for_uat=$(az account list --query "[?name=='${subscription_for_uat}'].id" --output tsv)
fi

"${repo_root}/scripts/terraform.sh" "$@"
