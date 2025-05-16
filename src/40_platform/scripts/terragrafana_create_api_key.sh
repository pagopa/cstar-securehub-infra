#!/bin/bash

set -euo pipefail

# Log file temporaneo per debug
LOG_FILE="/tmp/grafana_create_api_key_debug.log"
exec 3>>"$LOG_FILE"
echo "🔍 Avvio script: $(date)" >&3

# Leggi tutto l'input JSON in una variabile
RAW_INPUT=$(cat)
echo "📥 Input JSON da Terraform:" >&2
echo "$RAW_INPUT" >&2
echo "📥 Input JSON da Terraform:" >&3
echo "$RAW_INPUT" >&3

# Parsing JSON in variabili (una per riga, nessun default in jq)
eval "$(echo "$RAW_INPUT" | jq -r '@sh "RESOURCE_GROUP=\(.resource_group)"')" || true
eval "$(echo "$RAW_INPUT" | jq -r '@sh "GRAFANA_NAME=\(.grafana_name)"')" || true
eval "$(echo "$RAW_INPUT" | jq -r '@sh "SERVICE_ACCOUNT_NAME=\(.api_key_name)"')" || true
eval "$(echo "$RAW_INPUT" | jq -r '@sh "SERVICE_ACCOUNT_ROLE=\(.api_key_role)"')" || true
eval "$(echo "$RAW_INPUT" | jq -r '@sh "TTL_SECONDS=\(.api_key_ttl)"')" || true

# Validazione input
if [[ -z "${RESOURCE_GROUP:-}" || -z "${GRAFANA_NAME:-}" || -z "${SERVICE_ACCOUNT_NAME:-}" || -z "${TTL_SECONDS:-}" ]]; then
  echo "❌ Errore: uno o più parametri obbligatori sono mancanti" >&2
  echo "❌ Errore: parametri mancanti" >&3
  exit 1
fi

# Log parametri
echo "📌 Parametri estratti:" >&3
echo "RESOURCE_GROUP = $RESOURCE_GROUP" >&3
echo "GRAFANA_NAME   = $GRAFANA_NAME" >&3
echo "SERVICE_ACCOUNT_NAME = $SERVICE_ACCOUNT_NAME" >&3
echo "SERVICE_ACCOUNT_ROLE = $SERVICE_ACCOUNT_ROLE" >&3
echo "TTL_SECONDS = $TTL_SECONDS" >&3

# Verifica se il Service Account esiste già
echo "🔍 Controllo esistenza Service Account..." >&3
SERVICE_ACCOUNT_ID=$(az grafana service-account list \
  --name "$GRAFANA_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "[?name=='$SERVICE_ACCOUNT_NAME'].id | [0]" -o tsv || true)

if [[ -z "$SERVICE_ACCOUNT_ID" ]]; then
  echo "⚙️  Creazione nuovo Service Account..." >&3
  az grafana service-account create \
    --name "$GRAFANA_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --service-account "$SERVICE_ACCOUNT_NAME" \
    --role "$SERVICE_ACCOUNT_ROLE" \
    --output none
else
  echo "ℹ️ Service Account già esistente: $SERVICE_ACCOUNT_ID" >&3
fi

# Verifica se il token esiste già
echo "🔍 Controllo esistenza Token per il Service Account..." >&3
EXISTING_TOKENS=$(az grafana service-account token list \
  --name "$GRAFANA_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --service-account "$SERVICE_ACCOUNT_NAME" \
  --query "[?name=='$SERVICE_ACCOUNT_NAME-token'] | [].name" -o tsv)

if [[ -n "$EXISTING_TOKENS" ]]; then
  echo "♻️  Token esistente rilevato. Procedo con eliminazione per rigenerazione." >&3
  az grafana service-account token delete \
    --name "$GRAFANA_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --service-account "$SERVICE_ACCOUNT_NAME" \
    --token "$SERVICE_ACCOUNT_NAME-token"
fi

echo "⚙️  Creazione nuovo Token..." >&3
TOKEN_JSON=$(az grafana service-account token create \
  --name "$GRAFANA_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --service-account "$SERVICE_ACCOUNT_NAME" \
  --token "$SERVICE_ACCOUNT_NAME-token" \
  --time-to-live "$TTL_SECONDS" \
  --output json)

GRAFANA_TOKEN=$(echo "$TOKEN_JSON" | jq -r '.token')

if [[ -z "$GRAFANA_TOKEN" || "$GRAFANA_TOKEN" == "null" ]]; then
  echo "❌ Errore: token non generato correttamente" >&2
  echo "❌ JSON token: $TOKEN_JSON" >&3
  exit 1
fi

echo "✅ Script completato." >&3

# Output compatibile con Terraform
jq -n --arg api_key "$GRAFANA_TOKEN" '{"api_key":$api_key}'
