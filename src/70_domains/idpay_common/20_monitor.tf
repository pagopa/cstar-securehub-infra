resource "azurerm_resource_group" "idpay_monitoring_rg" {
  name     = "${local.project}-monitor-rg"
  location = var.location

  tags = module.tag_config.tags
}

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
  name                = "${local.project}-appinsights"
  location            = data.azurerm_resource_group.idpay_monitoring_rg.location
  resource_group_name = data.azurerm_resource_group.idpay_monitoring_rg.name
  tags                = module.tag_config.tags

  application_type = "other"

  workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

}
