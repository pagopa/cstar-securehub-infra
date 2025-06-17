#!/bin/bash

set -euo pipefail

# Log per debugging dettagliato
echo "🚀 Avvio script: $(date)" >&2

# Leggi input JSON
RAW_INPUT=$(cat)
echo "📥 Input JSON da Terraform:" >&2
echo "$RAW_INPUT" >&2

# Parsing input
eval "$(echo "$RAW_INPUT" | jq -r '@sh "HTTPS_ENDPOINT=\(.grafana_endpoint)"')" || true
eval "$(echo "$RAW_INPUT" | jq -r '@sh "TOKEN=\(.grafana_service_account_token)"')" || true

# Verifica parametri
if [[ -z "${HTTPS_ENDPOINT:-}" || -z "${TOKEN:-}" ]]; then
  echo "❌ Parametri mancanti (grafana_endpoint o token)" >&2
  exit 1
fi

echo "🔍 Endpoint: $HTTPS_ENDPOINT" >&2

# Validazione token
echo "🔐 Verifica token su $HTTPS_ENDPOINT/api/user..." >&2
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  "$HTTPS_ENDPOINT/api/user")

echo "🔁 Risposta HTTP: $RESPONSE" >&2

if [[ "$RESPONSE" -eq 200 ]]; then
  jq -n --arg status "valid" --arg message "Token valido" '{grafana_token_status: $status, grafana_token_message: $message}'
else
  echo "❌ Token non valido. HTTP $RESPONSE" >&2
  exit 1
fi
