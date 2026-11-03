#!/usr/bin/env bash
set -eo pipefail

usage() {
  echo "Usage: ./dashboard_folder.sh <plan|apply> <environment> <dashboard-folder> [base-ref]" >&2
  echo "  base-ref: git ref used to detect deleted dashboards (default: origin/main)" >&2
  exit 2
}

if [[ "$#" -lt 3 || "$#" -gt 4 ]]; then
  usage
fi

action=$1
environment=$2
dashboard_folder=$3
base_ref=${4:-origin/main}

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

if ! git rev-parse --verify --quiet "${base_ref}^{commit}" >/dev/null; then
  echo "Invalid git base ref: $base_ref (try 'git fetch' or pass a different ref)" >&2
  exit 1
fi

dashboard_root="env/$environment/dashboard"
dashboard_path="$dashboard_root/$dashboard_folder"

dashboard_targets=()
folder_targets=()
deleted_dashboards=()

contains() {
  local needle=$1
  shift
  local item
  for item in "$@"; do
    [[ "$item" == "$needle" ]] && return 0
  done
  return 1
}

add_targets() {
  local dashboard_file=$1
  local relative_path=${dashboard_file#"$dashboard_root"/}
  if [[ ! "$relative_path" =~ ^[A-Za-z0-9._/-]+$ ]]; then
    echo "Dashboard path cannot be safely passed to Terraform: $relative_path" >&2
    exit 1
  fi

  local dashboard_target="-target=grafana_dashboard.azure_monitor_grafana[\"$relative_path\"]"
  if ! contains "$dashboard_target" "${dashboard_targets[@]}"; then
    dashboard_targets+=("$dashboard_target")
  fi

  local folder_target="-target=grafana_folder.customfolder[\"${relative_path%/*}\"]"
  if ! contains "$folder_target" "${folder_targets[@]}"; then
    folder_targets+=("$folder_target")
  fi
}

# Dashboards present on disk (created or updated)
if [[ -d "$dashboard_path" ]]; then
  while IFS= read -r -d '' dashboard_file; do
    add_targets "$dashboard_file"
  done < <(find "$dashboard_path" -type f -print0)
fi

# Dashboards deleted compared to the base ref (committed or not), so that
# Terraform plans their destruction. Renames are treated as delete + add.
while IFS= read -r -d '' dashboard_file; do
  add_targets "$dashboard_file"
  deleted_dashboards+=("${dashboard_file#"$dashboard_root"/}")
done < <(git diff --relative --no-renames --diff-filter=D --name-only -z "$base_ref" -- "$dashboard_path")

if [[ "${#dashboard_targets[@]}" -eq 0 ]]; then
  echo "No dashboard files found in $dashboard_path nor deleted since $base_ref" >&2
  exit 1
fi

if [[ "${#deleted_dashboards[@]}" -gt 0 ]]; then
  printf 'Deleted dashboards since %s (will be destroyed):\n' "$base_ref"
  printf '  - %s\n' "${deleted_dashboards[@]}"
  printf '\n'
fi

printf 'Terraform command (not executed):\n'
printf '%q ' ./terraform.sh "$action" "$environment" "${folder_targets[@]}" "${dashboard_targets[@]}"
printf '\n'
