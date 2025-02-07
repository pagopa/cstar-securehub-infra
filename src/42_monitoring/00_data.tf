# Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.product}-adgroup-admin"
}

### Log Analytics
data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = local.log_analytics_workspace_name
  resource_group_name = local.monitor_resource_group_name
}
