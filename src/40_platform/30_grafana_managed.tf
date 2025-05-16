#
# 📊  Managed
#
resource "azurerm_dashboard_grafana" "grafana_managed" {
  name                              = "${local.product}-${var.location_short}-grafana"
  resource_group_name               = azurerm_resource_group.monitoring_rg.name
  location                          = var.location
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = true
  zone_redundancy_enabled           = false
  grafana_major_version             = 11

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
resource "azurerm_role_assignment" "grafana_dashboard_identity_roles" {

  for_each = toset([
    "Monitoring Data Reader",
    "Monitoring Reader",
    "Reader" ,
    "Log Analytics Reader",
  ])

  scope                = data.azurerm_subscription.current.id
  role_definition_name = each.key
  principal_id         = azurerm_dashboard_grafana.grafana_managed.identity[0].principal_id

  depends_on = [
    azurerm_dashboard_grafana.grafana_managed
  ]
}

#
# 👥 IAM Groups
#
locals {
  grafana_role_assignments = [
    {
      name            = "developers-viewer"
      role_definition = "Grafana Viewer"
      principal_id    = data.azuread_group.adgroup_developers.object_id
    },
    {
      name            = "admins-admin"
      role_definition = "Grafana Admin"
      principal_id    = data.azuread_group.adgroup_admin.object_id
    }
  ]
}

resource "azurerm_role_assignment" "grafana_dashboard_roles" {
  for_each             = { for ra in local.grafana_role_assignments : ra.name => ra }
  scope                = data.azurerm_subscription.current.id
  role_definition_name = each.value.role_definition
  principal_id         = each.value.principal_id

  depends_on = [
    azurerm_dashboard_grafana.grafana_managed
  ]
}


#
# 📦 Grafana dashboard modules
#
data "external" "grafana_generate_service_account" {
  program = ["bash", "${path.module}/scripts/terragrafana_create_api_key.sh"]

  query = {
    resource_group = azurerm_resource_group.monitoring_rg.name
    grafana_name   = azurerm_dashboard_grafana.grafana_managed.name
    grafana_service_account_name   = "grafana-ci-service-account"
    grafana_service_account_role   = "Admin"
  }
}

data "azurerm_key_vault_secret" "grafana_dashboard_bot_api_key" {
  name         = "cstar-itn-grafana-dashboard-bot-api-key"
  key_vault_id = data.azurerm_key_vault.core_kv.id
}

output "grfana" {
  value = data.external.grafana_generate_service_account.result
}


module "auto_dashboard" {
  source = "./.terraform/modules/__v4__/grafana_dashboard"

  grafana_api_key      = data.azurerm_key_vault_secret.grafana_dashboard_bot_api_key.value
  grafana_url          = azurerm_dashboard_grafana.grafana_managed.endpoint
  monitor_workspace_id = azurerm_log_analytics_workspace.monitoring_log_analytics_workspace.id
  prefix               = "cstar"
}
