resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${local.project}-law"
  location            = data.azurerm_resource_group.idpay_monitoring_rg.location
  resource_group_name = data.azurerm_resource_group.idpay_monitoring_rg.name
  tags                = module.tag_config.tags


  sku               = var.law_sku
  retention_in_days = var.law_retention_in_days
  daily_quota_gb    = var.law_daily_quota_gb


  lifecycle {
    ignore_changes = [
      sku
    ]
  }
}

### 🔍 Application insights
resource "azurerm_application_insights" "idpay_application_insights" {
  name                 = "${local.project}-appinsights"
  location             = data.azurerm_resource_group.idpay_monitoring_rg.location
  resource_group_name  = data.azurerm_resource_group.idpay_monitoring_rg.name
  daily_data_cap_in_gb = var.law_daily_quota_gb
  tags                 = module.tag_config.tags

  application_type = "other"

  workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

}


### 🔍 Logger APIM
resource "azurerm_api_management_logger" "apim_logger" {
  name                = "${local.project}-apim-logger"
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_api_management.apim.resource_group_name
  resource_id         = azurerm_application_insights.idpay_application_insights.id

  application_insights {
    instrumentation_key = azurerm_application_insights.idpay_application_insights.instrumentation_key
  }
}

### Action Group
resource "azurerm_monitor_action_group" "email" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = local.monitor_action_group_email_name
  resource_group_name = local.monitor_rg
  short_name          = "pari-email"
  enabled             = true

  dynamic "email_receiver" {
    for_each = var.env_short == "u" ? [1] : []
    content {
      name                    = "pari-alerts-email_-EmailAction-"
      email_address           = "pari.alert.test@gmail.com"
      use_common_alert_schema = false
    }
  }
}
