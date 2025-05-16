#!/bin/bash

set -euo pipefail

# Leggi tutto l'input JSON in una variabile
RAW_INPUT=$(cat)
echo "📥 Input JSON da Terraform:" >&2
echo "$RAW_INPUT" >&2

# Parsing JSON in variabili
eval "$(echo "$RAW_INPUT" | jq -r '@sh "RESOURCE_GROUP=\(.resource_group)"')" || true
eval "$(echo "$RAW_INPUT" | jq -r '@sh "GRAFANA_NAME=\(.grafana_name)"')" || true
eval "$(echo "$RAW_INPUT" | jq -r '@sh "SERVICE_ACCOUNT_NAME=\(.grafana_service_account_name)"')" || true
eval "$(echo "$RAW_INPUT" | jq -r '@sh "SERVICE_ACCOUNT_ROLE=\(.grafana_service_account_role)"')" || true

# Validazione input
if [[ -z "${RESOURCE_GROUP:-}" || -z "${GRAFANA_NAME:-}" || -z "${SERVICE_ACCOUNT_NAME:-}" ]]; then
  echo "❌ Errore: uno o più parametri obbligatori sono mancanti" >&2
  exit 1
fi

# Log parametri
echo "📌 Parametri estratti:" >&2
echo "RESOURCE_GROUP = $RESOURCE_GROUP" >&2
echo "GRAFANA_NAME   = $GRAFANA_NAME" >&2
echo "SERVICE_ACCOUNT_NAME = $SERVICE_ACCOUNT_NAME" >&2
echo "SERVICE_ACCOUNT_ROLE = $SERVICE_ACCOUNT_ROLE" >&2

# Verifica se il Service Account esiste già
echo "🔍 Controllo esistenza Service Account..." >&2
SERVICE_ACCOUNT_ID=$(az grafana service-account list \
  --name "$GRAFANA_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "[?name=='$SERVICE_ACCOUNT_NAME'].id | [0]" -o tsv || true)

GRAFANA_SERVICE_ACCOUNT_STATUS="existing"
GRAFANA_SERVICE_ACCOUNT_MESSAGE="Service Account già esistente"

if [[ -z "$SERVICE_ACCOUNT_ID" ]]; then
  echo "⚙️  Creazione nuovo Service Account..." >&2
  az grafana service-account create \
    --name "$GRAFANA_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --service-account "$SERVICE_ACCOUNT_NAME" \
    --role "$SERVICE_ACCOUNT_ROLE" \
    --output none
  GRAFANA_SERVICE_ACCOUNT_STATUS="created"
  GRAFANA_SERVICE_ACCOUNT_MESSAGE="Service Account creato con successo"
fi

# Output compatibile con Terraform
jq -n --arg status "$GRAFANA_SERVICE_ACCOUNT_STATUS" --arg message "$GRAFANA_SERVICE_ACCOUNT_MESSAGE" --arg name "$SERVICE_ACCOUNT_NAME" '{grafana_service_account_status: $status, grafana_service_account_message: $message, grafana_service_account_name: $name}'
