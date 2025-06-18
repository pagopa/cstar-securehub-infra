### RG for monitoring
resource "azurerm_resource_group" "monitoring_rg" {
  name     = "${local.project}-monitoring-rg"
  location = var.location

  tags = module.tag_config.tags
}

### 📝 log analytics workspace
resource "azurerm_log_analytics_workspace" "monitoring_log_analytics_workspace" {
  name                = "${local.project}-monitoring-law"
  location            = azurerm_resource_group.monitoring_rg.location
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  sku                 = var.monitoring_law_sku
  retention_in_days   = var.monitoring_law_retention_in_days
  daily_quota_gb      = var.monitoring_law_daily_quota_gb

  tags = module.tag_config.tags

  lifecycle {
    ignore_changes = [
      sku
    ]
  }
}

### 🔍 Application insights
resource "azurerm_application_insights" "monitoring_application_insights" {
  name                = "${local.project}-monitoring-appinsights"
  location            = azurerm_resource_group.monitoring_rg.location
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  application_type    = "other"

  workspace_id = azurerm_log_analytics_workspace.monitoring_log_analytics_workspace.id

  tags = module.tag_config.tags
}

#--------------------------------------------------------------------------------------------
# Action Groups
#--------------------------------------------------------------------------------------------
resource "azurerm_monitor_action_group" "cstar_status" {
  name                = "cstar_status"
  short_name          = "cstar_status"
  resource_group_name = azurerm_resource_group.monitoring_rg.name

  email_receiver {
    name                    = data.azurerm_key_vault_secret.email_google_cstar_status.name
    email_address           = data.azurerm_key_vault_secret.email_google_cstar_status.value
    use_common_alert_schema = true
  }

  email_receiver {
    name                    = data.azurerm_key_vault_secret.email_slack_cstar_status.name
    email_address           = data.azurerm_key_vault_secret.email_slack_cstar_status.value
    use_common_alert_schema = true
  }

  tags = module.tag_config.tags
}

data "azurerm_monitor_action_group" "infra_opsgenie" {
  count               = var.env_short == "p" ? 1 : 0
  resource_group_name = "${local.product}-monitor-rg"
  name                = "CstarInfraOpsgenie"
}
