#
# Validate Grafana token
#
data "external" "validate_grafana_token" {
  program = ["${path.module}/scripts/terragrafana_validate_token.sh"]

  query = {
    grafana_endpoint              = azurerm_dashboard_grafana.grafana_managed.endpoint
    grafana_service_account_token = azurerm_key_vault_secret.grafana_service_account_token.value
  }
}

module "auto_dashboard" {
  source = "./.terraform/modules/__v4__/grafana_dashboard"

  grafana_api_key      = azurerm_key_vault_secret.grafana_service_account_token.value
  grafana_url          = azurerm_dashboard_grafana.grafana_managed.endpoint
  monitor_workspace_id = azurerm_log_analytics_workspace.monitoring_log_analytics_workspace.id
  prefix               = "cstar"
}

output "grafana_token_validation" {
  value = data.external.validate_grafana_token.result
}
