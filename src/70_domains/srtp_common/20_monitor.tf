resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${local.project}-law"
  location            = data.azurerm_resource_group.srtp_monitoring_rg.location
  resource_group_name = data.azurerm_resource_group.srtp_monitoring_rg.name
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

### 🔍 Application insights
resource "azurerm_application_insights" "srtp_application_insights" {
  name                = "${local.project}-appinsights"
  location            = data.azurerm_resource_group.srtp_monitoring_rg.location
  resource_group_name = data.azurerm_resource_group.srtp_monitoring_rg.name
  application_type    = "other"

  workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  tags = module.tag_config.tags
}
