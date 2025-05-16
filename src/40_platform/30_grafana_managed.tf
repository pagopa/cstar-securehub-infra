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
    "Reader",
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
  program = ["bash", "${path.module}/scripts/terragrafana_generate_service_account.sh"]

  query = {
    resource_group               = azurerm_resource_group.monitoring_rg.name
    grafana_name                 = azurerm_dashboard_grafana.grafana_managed.name
    grafana_service_account_name = "grafana-service-account"
    grafana_service_account_role = "Admin"
  }
}

resource "azurerm_key_vault_secret" "grafana_service_account_name" {
  name         = "grafana-itn-service-account-name"
  key_vault_id = data.azurerm_key_vault.core_kv.id
  value        = data.external.grafana_generate_service_account.result["grafana_service_account_name"]
  depends_on = [
    data.external.grafana_generate_service_account
  ]
}

#
# Validate Grafana token
#
data "azurerm_key_vault_secret" "grafana_service_account_token" {
  name         = "grafana-itn-service-account-token"
  key_vault_id = data.azurerm_key_vault.core_kv.id
}

data "external" "validate_grafana_token" {
  program = ["${path.module}/scripts/terragrafana_validate_token.sh"]

  query = {
    grafana_endpoint              = azurerm_dashboard_grafana.grafana_managed.endpoint
    grafana_service_account_token = data.azurerm_key_vault_secret.grafana_service_account_token.value
  }
}

module "auto_dashboard" {
  source = "./.terraform/modules/__v4__/grafana_dashboard"

  grafana_api_key      = data.azurerm_key_vault_secret.grafana_service_account_token.value
  grafana_url          = azurerm_dashboard_grafana.grafana_managed.endpoint
  monitor_workspace_id = azurerm_log_analytics_workspace.monitoring_log_analytics_workspace.id
  prefix               = "cstar"
}

output "grafana_token_validation" {
  value = data.external.validate_grafana_token.result
}
