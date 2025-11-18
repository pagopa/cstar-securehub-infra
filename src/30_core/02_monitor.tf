resource "azurerm_resource_group" "monitor_rg" {
  name     = "${local.project}-monitor-rg"
  location = var.location

  tags = module.tag_config.tags
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${local.project}-law"
  location            = azurerm_resource_group.monitor_rg.location
  resource_group_name = azurerm_resource_group.monitor_rg.name
  sku                 = var.law_sku
  retention_in_days   = var.law_retention_in_days
  daily_quota_gb      = var.law_daily_quota_gb

  tags = module.tag_config.tags

  lifecycle {
    ignore_changes = [
      sku
    ]
  }
}

# Application insights
resource "azurerm_application_insights" "application_insights" {
  name                = "${local.project}-appinsights"
  location            = azurerm_resource_group.monitor_rg.location
  resource_group_name = azurerm_resource_group.monitor_rg.name
  application_type    = "other"

  workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  tags = module.tag_config.tags
}

resource "azurerm_monitor_action_group" "email" {
  name                = "PagoPA"
  resource_group_name = azurerm_resource_group.monitor_rg.name
  short_name          = "PagoPA"

  email_receiver {
    name                    = "sendtooperations"
    email_address           = data.azurerm_key_vault_secret.monitor_notification_email.value
    use_common_alert_schema = true
  }

  tags = module.tag_config.tags
}

resource "azurerm_monitor_action_group" "slack" {
  name                = "SlackPagoPA"
  resource_group_name = azurerm_resource_group.monitor_rg.name
  short_name          = "SlackPagoPA"

  email_receiver {
    name                    = "sendtoslack"
    email_address           = data.azurerm_key_vault_secret.monitor_notification_slack_email.value
    use_common_alert_schema = true
  }

  tags = module.tag_config.tags
}

resource "azurerm_monitor_action_group" "cstar_infra_opsgenie" { #
  count = var.env_short == "p" ? 1 : 0

  name                = "CstarInfraOpsgenie"
  resource_group_name = azurerm_resource_group.monitor_rg.name
  short_name          = "InfrOpsgenie"

  webhook_receiver {
    name                    = "CstarINFRAOpsgenieWebhook"
    service_uri             = "https://api.opsgenie.com/v1/json/azure?apiKey=${data.azurerm_key_vault_secret.opsgenie_cstar_infra_webhook_key[0].value}"
    use_common_alert_schema = true
  }

  tags = module.tag_config.tags
}

#
# Azure Monitor Workspace
#
resource "azurerm_monitor_workspace" "monitor_workspace" {
  name                          = "${var.prefix}-${var.env_short}-${var.location}-monitor-workspace"
  resource_group_name           = azurerm_resource_group.monitor_rg.name
  location                      = var.location
  public_network_access_enabled = false

  tags = module.tag_config.tags
}

resource "azurerm_private_endpoint" "monitor_workspace_private_endpoint" {
  name                = "${local.product}-monitor-workspace-pe"
  location            = azurerm_monitor_workspace.monitor_workspace.location
  resource_group_name = azurerm_monitor_workspace.monitor_workspace.resource_group_name
  subnet_id           = data.azurerm_subnet.spoke_data_monitor_workspace_snet.id

  private_service_connection {
    name                           = "monitorworkspaceconnection"
    private_connection_resource_id = azurerm_monitor_workspace.monitor_workspace.id
    is_manual_connection           = false
    subresource_names              = ["prometheusMetrics"]
  }

  private_dns_zone_group {
    name                 = "${var.prefix}-workspace-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.prometheus_dns_zone.id]
  }


  depends_on = [azurerm_monitor_workspace.monitor_workspace]

  tags = module.tag_config.tags
}
