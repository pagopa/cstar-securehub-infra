resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${local.project}-law"
  location            = var.location
  resource_group_name = local.monitor_rg_name
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
resource "azurerm_application_insights" "application_insights" {
  name                 = "${local.project}-appinsights"
  location             = var.location
  resource_group_name  = local.monitor_rg_name
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
  resource_id         = azurerm_application_insights.application_insights.id

  application_insights {
    instrumentation_key = azurerm_application_insights.application_insights.instrumentation_key
  }
}

resource "azurerm_key_vault_secret" "appinisights_connection_string_kv" {
  name         = "appinsights-connection-string"
  value        = azurerm_application_insights.application_insights.connection_string
  key_vault_id = data.azurerm_key_vault.domain_kv.id
  tags         = module.tag_config.tags
}
