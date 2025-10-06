#
# 📊  Managed
#
resource "azurerm_dashboard_grafana" "grafana_managed" {
  name                = "${local.product}-${var.location_short}-grafana"
  resource_group_name = module.default_resource_groups[var.domain].resource_group_names["monitoring"]
  location            = var.location
  tags                = module.tag_config.tags

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
    resource_group               = module.default_resource_groups[var.domain].resource_group_names["monitoring"]
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
    data.external.grafana_generate_service_account,
    azurerm_role_assignment.grafana_dashboard_roles
  ]
}

resource "azurerm_key_vault_secret" "grafana_service_account_token" {
  name         = "grafana-itn-service-account-token-value"
  key_vault_id = data.azurerm_key_vault.core_kv.id
  value        = "genete token manually on grafana dashboard on settings using `grafana-service-account`"
  depends_on = [
    data.external.grafana_generate_service_account,
    azurerm_role_assignment.grafana_dashboard_roles
  ]
  tags = module.tag_config.tags

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "azurerm_dashboard_grafana_managed_private_endpoint" "kusto" {
  grafana_id                   = azurerm_dashboard_grafana.grafana_managed.id
  name                         = "${title(var.prefix)}${title(var.env)}${title(var.location_short)}GrafPam"
  location                     = azurerm_dashboard_grafana.grafana_managed.location
  private_link_resource_id     = azurerm_kusto_cluster.data_explorer_cluster.id
  group_ids                    = ["cluster"]
  private_link_resource_region = azurerm_dashboard_grafana.grafana_managed.location

  tags = module.tag_config.tags
}

data "azapi_resource" "privatelink_private_endpoint_connection" {
  type                   = "Microsoft.Kusto/clusters@2023-08-15"
  resource_id            = azurerm_kusto_cluster.data_explorer_cluster.id
  response_export_values = ["properties.privateEndpointConnections."]

  depends_on = [
    azurerm_dashboard_grafana_managed_private_endpoint.kusto
  ]
}

locals {
  privatelink_private_endpoint_connection_name = data.azapi_resource.privatelink_private_endpoint_connection.output.properties.privateEndpointConnections[2].id
}

resource "azapi_resource_action" "kusto_approve_pe" {
  type        = "Microsoft.Kusto/clusters/privateEndpointConnections@2024-04-13"
  resource_id = local.privatelink_private_endpoint_connection_name
  method      = "PUT"

  body = {
    properties = {
      privateLinkServiceConnectionState = {
        description = "Approved via Terraform - ${azurerm_dashboard_grafana_managed_private_endpoint.kusto.name}"
        status      = "Approved"
      }
    }
  }
}
