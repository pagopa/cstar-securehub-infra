#!/usr/bin/env bash
set -eo pipefail

usage() {
  echo "Usage: ./dashboard_folder.sh <plan|apply> <environment> <dashboard-folder>" >&2
  exit 2
}

if [[ "$#" -ne 3 ]]; then
  usage
fi

action=$1
environment=$2
dashboard_folder=$3

if [[ "$action" != "plan" && "$action" != "apply" ]]; then
  echo "Invalid action: $action (expected plan or apply)" >&2
  exit 2
fi

if [[ ! "$environment" =~ ^[A-Za-z0-9_-]+$ ]]; then
  echo "Invalid environment: $environment" >&2
  exit 2
fi

if [[ ! "$dashboard_folder" =~ ^[A-Za-z0-9_.-]+$ || "$dashboard_folder" == "." || "$dashboard_folder" == ".." ]]; then
  echo "Invalid dashboard folder: $dashboard_folder" >&2
  exit 2
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"

if [[ ! -f "env/$environment/backend.ini" || ! -f "env/$environment/terraform.tfvars" ]]; then
  echo "Environment configuration not found: $environment" >&2
  exit 1
fi

dashboard_root="env/$environment/dashboard"
dashboard_path="$dashboard_root/$dashboard_folder"
if [[ ! -d "$dashboard_path" ]]; then
  echo "Dashboard folder not found: $dashboard_folder ($environment)" >&2
  exit 1
fi

dashboard_targets=()
folder_targets=()
while IFS= read -r -d '' dashboard_file; do
  relative_path=${dashboard_file#"$dashboard_root"/}
  if [[ ! "$relative_path" =~ ^[A-Za-z0-9._/-]+$ ]]; then
    echo "Dashboard path cannot be safely passed to Terraform: $relative_path" >&2
    exit 1
  fi

  dashboard_targets+=("-target=grafana_dashboard.azure_monitor_grafana[\"$relative_path\"]")

  relative_folder=${relative_path%/*}
  folder_target="-target=grafana_folder.customfolder[\"$relative_folder\"]"
  is_new_folder=true
  for existing_target in "${folder_targets[@]}"; do
    if [[ "$existing_target" == "$folder_target" ]]; then
      is_new_folder=false
      break
    fi
  done
  if [[ "$is_new_folder" == true ]]; then
    folder_targets+=("$folder_target")
  fi
done < <(find "$dashboard_path" -type f -print0)

if [[ "${#dashboard_targets[@]}" -eq 0 ]]; then
  echo "No dashboard files found in: $dashboard_path" >&2
  exit 1
fi

exec ./terraform.sh "$action" "$environment" "${folder_targets[@]}" "${dashboard_targets[@]}"
