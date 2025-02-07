#!/bin/bash

# 🚀 Script for Terraform external provider and local execution
#
# 📝 Local execution example:
# ./temporal_postgres_schema_setup.sh << EOF
# {
#   "endpoint": "your-postgresql-server.postgres.database.azure.com",
#   "port": "5432",
#   "username": "your-username@your-postgresql-server",
#   "password": "your-password",
#   "schema_version": "1.14",
#   "docker_image": "temporalio/admin-tools:1.25.2-tctl-1.18.1-cli-1.1.1",
#   "debug": "true"
# }
# EOF

set +e

# 🔍 Debug function
debug_log() {
  if [ "${DEBUG}" = "true" ]; then
      echo "🔍 DEBUG: $1" >&2
  fi
}

# 🔄 Function to handle script exit
cleanup_and_exit() {
  local status=$1
  local message=$2
  local exit_code=$3
  local output=$4

  debug_log "Preparing final JSON output"
  jq -n \
      --arg status "$status" \
      --arg message "$message" \
      --arg exit_code "$exit_code" \
      --arg output "$output" \
      '{
          "status": $status,
          "message": $message,
          "exit_code": $exit_code,
          "output": $output
      }'

  exit 0
}

# 📥 Reading JSON input
debug_log "Reading input from JSON"
JSON_INPUT=$(cat)

# Verify JSON input is valid
if ! echo "$JSON_INPUT" | jq empty 2>/dev/null; then
  cleanup_and_exit "error" "❌ Invalid JSON input" "1" "The provided input is not valid JSON"
fi

debug_log "Parsing input values..."

# Parse each value individually and show the results
POSTGRES_ENDPOINT=$(echo "$JSON_INPUT" | jq -r '.endpoint // empty')
debug_log "📌 ENDPOINT: ${POSTGRES_ENDPOINT}"

POSTGRES_PORT=$(echo "$JSON_INPUT" | jq -r '.port // empty')
debug_log "🔌 PORT: ${POSTGRES_PORT}"

POSTGRES_USERNAME=$(echo "$JSON_INPUT" | jq -r '.username // empty')
debug_log "👤 USERNAME: ${POSTGRES_USERNAME}"

POSTGRES_PASSWORD=$(echo "$JSON_INPUT" | jq -r '.password // empty')
debug_log "🔑 PASSWORD: ${POSTGRES_PASSWORD}"

SCHEMA_VERSION=$(echo "$JSON_INPUT" | jq -r '.schema_version // empty')
debug_log "📊 SCHEMA_VERSION: ${SCHEMA_VERSION}"

DOCKER_IMAGE=$(echo "$JSON_INPUT" | jq -r '.docker_image // empty')
debug_log "🐳 DOCKER_IMAGE: ${DOCKER_IMAGE}"

DEBUG=$(echo "$JSON_INPUT" | jq -r '.debug // "false"')
debug_log "🔧 DEBUG: ${DEBUG}"

debug_log "-----------------------------------"

# Verify required inputs
if [ -z "$POSTGRES_ENDPOINT" ] || [ -z "$POSTGRES_USERNAME" ] || [ -z "$POSTGRES_PASSWORD" ] || \
 [ -z "$SCHEMA_VERSION" ] || [ -z "$DOCKER_IMAGE" ] || [ -z "$POSTGRES_PORT" ]; then
  cleanup_and_exit "error" "❌ Missing required parameters" "1" "One or more required parameters are missing"
fi

# 🔍 Check if schema_version table exists in PostgreSQL temporal database
debug_log "Checking if schema_version table exists..."

check_table_cmd="SELECT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'schema_version');"
table_check=$(docker run --rm \
  -e PGPASSWORD="${POSTGRES_PASSWORD}" \
  -e PGSSLMODE=require \
  postgres:14-alpine \
  psql \
  --host="${POSTGRES_ENDPOINT}" \
  --port="${POSTGRES_PORT}" \
  --username="${POSTGRES_USERNAME}" \
  --dbname="temporal" \
  --no-align \
  --tuples-only \
  --command="${check_table_cmd}" \
  -v ON_ERROR_STOP=1 \
  2>&1)

table_check_exit_code=$?
debug_log "Table check exit code: ${table_check_exit_code}"
debug_log "Table check output: ${table_check}"

if [ $table_check_exit_code -ne 0 ]; then
  cleanup_and_exit "error" "❌ Failed to check schema_version table" "${table_check_exit_code}" "${table_check}"
fi

table_exists=$(echo "${table_check}" | tr -d '[:space:]')
debug_log "Table check result: ${table_exists}"

if [ "$table_exists" = "t" ]; then
  debug_log "schema_version table exists, executing update command..."
  # Execute update command
  output=$(SQL_DATABASE=temporal docker run --rm --entrypoint temporal-sql-tool \
      "${DOCKER_IMAGE}" \
      --endpoint "${POSTGRES_ENDPOINT}" \
      --port "${POSTGRES_PORT}" \
      --user "${POSTGRES_USERNAME}" \
      --password "${POSTGRES_PASSWORD}" \
      --plugin postgres12 \
      --tls \
      --tls-disable-host-verification \
      update -schema-dir schema/postgresql/v12/temporal/versioned 2>&1)
else
  debug_log "schema_version table does not exist, executing setup command..."
  # Execute setup command
  output=$(SQL_DATABASE=temporal docker run --rm --entrypoint temporal-sql-tool \
      "${DOCKER_IMAGE}" \
      --endpoint "${POSTGRES_ENDPOINT}" \
      --port "${POSTGRES_PORT}" \
      --user "${POSTGRES_USERNAME}" \
      --password "${POSTGRES_PASSWORD}" \
      --plugin postgres12 \
      --tls \
      --tls-disable-host-verification \
      setup-schema --version "${SCHEMA_VERSION}" --schema-name postgresql/v12/temporal 2>&1)
fi

exit_code=$?
debug_log "Command exit code: ${exit_code}"
debug_log "Command output: ${output}"

# 🔍 Verify execution result
debug_log "Verifying execution results..."
if [ $exit_code -eq 0 ]; then
  # 🔬 Additional check in output for possible hidden errors
  if echo "$output" | grep -i "error\|exception\|failed" > /dev/null; then
      cleanup_and_exit "error" "❌ Schema operation failed. Found error in output: ${output}" "${exit_code}" "${output}"
  else
      operation_type=$([[ "$table_exists" = "t" ]] && echo "update" || echo "setup")
      cleanup_and_exit "success" "✅ Schema ${operation_type} completed successfully" "${exit_code}" "${output}"
  fi
else
  operation_type=$([[ "$table_exists" = "t" ]] && echo "update" || echo "setup")
  cleanup_and_exit "error" "❌ Schema ${operation_type} failed with exit code ${exit_code}. Error: ${output}" "${exit_code}" "${output}"
fi
