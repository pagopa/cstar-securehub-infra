resource "azurerm_resource_group" "monitoring_rg" {
  name     = "${local.project}-monitoring-rg"
  location = var.location

  tags = var.tags
}

resource "azurerm_log_analytics_workspace" "monitoring_log_analytics_workspace" {
  name                = "${local.project}-monitoring-law"
  location            = azurerm_resource_group.monitoring_rg.location
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  sku                 = var.monitoring_law_sku
  retention_in_days   = var.monitoring_law_retention_in_days
  daily_quota_gb      = var.monitoring_law_daily_quota_gb

  tags = var.tags

  lifecycle {
    ignore_changes = [
      sku
    ]
  }
}

# Application insights
resource "azurerm_application_insights" "monitoring_application_insights" {
  name                = "${local.project}-monitoring-appinsights"
  location            = azurerm_resource_group.monitoring_rg.location
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  application_type    = "other"

  workspace_id = azurerm_log_analytics_workspace.monitoring_log_analytics_workspace.id

  tags = var.tags
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

  tags = var.tags
}
