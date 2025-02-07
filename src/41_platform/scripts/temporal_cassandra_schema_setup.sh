#!/bin/bash

# 🚀 Script for Terraform external provider and local execution
#
# 📝 Local execution example:
# ./setup_schema.sh << EOF
# {
#   "endpoint": "cstar-d-platform-temporal-cassandra-account.cassandra.cosmos.azure.com",
#   "port": "10350",
#   "username": "your-username",
#   "password": "your-password",
#   "schema_version": "1.11",
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

# Verifica che l'input sia un JSON valido
if ! echo "$JSON_INPUT" | jq empty 2>/dev/null; then
    cleanup_and_exit "error" "❌ Invalid JSON input" "1" "The provided input is not valid JSON"
fi

echo "🔍 Parsing input values..." >&2

# Parse each value individually and show the results
CASSANDRA_ENDPOINT=$(echo "$JSON_INPUT" | jq -r '.endpoint // empty')
echo "📌 ENDPOINT: ${CASSANDRA_ENDPOINT}" >&2

CASSANDRA_PORT=$(echo "$JSON_INPUT" | jq -r '.port // "10350"')
echo "🔌 PORT: ${CASSANDRA_PORT}" >&2

CASSANDRA_USERNAME=$(echo "$JSON_INPUT" | jq -r '.username // empty')
echo "👤 USERNAME: ${CASSANDRA_USERNAME}" >&2

CASSANDRA_PASSWORD=$(echo "$JSON_INPUT" | jq -r '.password // empty')
echo "🔑 PASSWORD: ${CASSANDRA_PASSWORD}" >&2

SCHEMA_VERSION=$(echo "$JSON_INPUT" | jq -r '.schema_version // empty')
echo "📊 SCHEMA_VERSION: ${SCHEMA_VERSION}" >&2

DOCKER_IMAGE=$(echo "$JSON_INPUT" | jq -r '.docker_image // empty')
echo "🐳 DOCKER_IMAGE: ${DOCKER_IMAGE}" >&2

DEBUG=$(echo "$JSON_INPUT" | jq -r '.debug // "false"')
echo "🔧 DEBUG: ${DEBUG}" >&2

echo "-----------------------------------" >&2

# Verify required inputs
if [ -z "$CASSANDRA_ENDPOINT" ] || [ -z "$CASSANDRA_USERNAME" ] || [ -z "$CASSANDRA_PASSWORD" ] || \
   [ -z "$SCHEMA_VERSION" ] || [ -z "$DOCKER_IMAGE" ]; then
    cleanup_and_exit "error" "❌ Missing required parameters" "1" "One or more required parameters are missing"
fi

# Combine endpoint and port for temporal-cassandra-tool
CASSANDRA_FULL_ENDPOINT="${CASSANDRA_ENDPOINT}:${CASSANDRA_PORT}"
debug_log "Full endpoint: ${CASSANDRA_FULL_ENDPOINT}"

# 🔍 Check if schema_version table exists using cqlsh from temporal admin tools
debug_log "Checking if schema_version table exists..."

check_table_cmd="SELECT table_name FROM system_schema.tables WHERE keyspace_name='temporal' AND table_name='schema_version';"
table_check=$(docker run --rm \
    --entrypoint cqlsh \
    -e SSL_VERSION=TLSv1_2 \
    -e SSL_VALIDATE=false \
    "${DOCKER_IMAGE}" \
    "${CASSANDRA_ENDPOINT}" "${CASSANDRA_PORT}" \
    -u "${CASSANDRA_USERNAME}" \
    -p "${CASSANDRA_PASSWORD}" \
    --ssl \
    -e "${check_table_cmd}" 2>&1)

table_check_exit_code=$?
debug_log "Table check exit code: ${table_check_exit_code}"
debug_log "Table check output: ${table_check}"

if [ $table_check_exit_code -ne 0 ]; then
    cleanup_and_exit "error" "❌ Failed to check schema_version table" "${table_check_exit_code}" "${table_check}"
fi

table_exists=$(echo "${table_check}" | grep -c "schema_version")
debug_log "Table check result: ${table_exists}"

if [ "$table_exists" -gt 0 ]; then
    debug_log "schema_version table exists, executing update command..."
    # Execute update command
    output=$(CASSANDRA_KEYSPACE=temporal docker run --rm --entrypoint temporal-cassandra-tool \
        "${DOCKER_IMAGE}" \
        --endpoint "${CASSANDRA_FULL_ENDPOINT}" \
        --user "${CASSANDRA_USERNAME}" \
        --password "${CASSANDRA_PASSWORD}" \
        --tls \
        --tls-disable-host-verification \
        update -schema-dir schema/cassandra/temporal 2>&1)
else
    debug_log "schema_version table does not exist, executing setup command..."
    # Execute setup command
    output=$(CASSANDRA_KEYSPACE=temporal docker run --rm --entrypoint temporal-cassandra-tool \
        "${DOCKER_IMAGE}" \
        --endpoint "${CASSANDRA_FULL_ENDPOINT}" \
        --user "${CASSANDRA_USERNAME}" \
        --password "${CASSANDRA_PASSWORD}" \
        --tls \
        --tls-disable-host-verification \
        setup-schema --version "${SCHEMA_VERSION}" --schema-name cassandra/temporal 2>&1)
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
        operation_type=$([[ "$table_exists" -gt 0 ]] && echo "update" || echo "setup")
        cleanup_and_exit "success" "✅ Schema ${operation_type} completed successfully" "${exit_code}" "${output}"
    fi
else
    operation_type=$([[ "$table_exists" -gt 0 ]] && echo "update" || echo "setup")
    cleanup_and_exit "error" "❌ Schema ${operation_type} failed with exit code ${exit_code}. Error: ${output}" "${exit_code}" "${output}"
fi
