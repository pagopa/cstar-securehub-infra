#
# 📊  Managed
#
resource "azurerm_dashboard_grafana" "grafana_dashboard" {
  name                              = "${local.product}-${var.location_short}-grafana"
  resource_group_name               = azurerm_resource_group.monitoring_rg.name
  location                          = var.location
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = true
  zone_redundancy_enabled           = false
  grafana_major_version             = 10

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      azure_monitor_workspace_integrations
    ]
  }

  tags = var.tags
}

#
# 👤 Users & Groups IAM
#
resource "azurerm_role_assignment" "grafana_dashboard_monitoring_reader_identity" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.grafana_dashboard.identity[0].principal_id
}

resource "azurerm_role_assignment" "grafana_dashboard_monitoring_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Grafana Viewer"
  principal_id         = data.azuread_group.adgroup_developers.id
}

#
# 👷🏻‍♂️ Admins IAM
#
resource "azurerm_role_assignment" "grafana_dashboard_monitoring_admins" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Grafana Admin"
  principal_id         = data.azuread_group.adgroup_admin.id
}

#
# 📦 Grafana dashboard modules
#

data "azurerm_key_vault_secret" "grafana_dashboard_bot_api_key" {
  name         = "cstar-itn-grafana-dashboard-bot-api-key"
  key_vault_id = data.azurerm_key_vault.core_kv.id
}

module "auto_dashboard" {
  source = "./.terraform/modules/__v4__/grafana_dashboard"

  grafana_api_key      = data.azurerm_key_vault_secret.grafana_dashboard_bot_api_key.value
  grafana_url          = azurerm_dashboard_grafana.grafana_dashboard.endpoint
  monitor_workspace_id = azurerm_log_analytics_workspace.monitoring_log_analytics_workspace.id
  prefix               = "cstar"
}
