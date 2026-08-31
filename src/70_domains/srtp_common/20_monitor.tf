resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${local.project}-law"
  location            = data.azurerm_resource_group.srtp_monitoring_rg.location
  resource_group_name = data.azurerm_resource_group.srtp_monitoring_rg.name
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

resource "azurerm_role_assignment" "platform_adf_to_srtp_law" {
  scope                = azurerm_log_analytics_workspace.log_analytics_workspace.id
  role_definition_name = "Log Analytics Data Reader"
  principal_id         = data.azurerm_data_factory.data_factory.identity[0].principal_id
}

### 🔍 Application insights
resource "azurerm_application_insights" "srtp_application_insights" {
  name                 = "${local.project}-appinsights"
  location             = data.azurerm_resource_group.srtp_monitoring_rg.location
  resource_group_name  = data.azurerm_resource_group.srtp_monitoring_rg.name
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
  resource_id         = azurerm_application_insights.srtp_application_insights.id

  application_insights {
    instrumentation_key = azurerm_application_insights.srtp_application_insights.instrumentation_key
  }
}
