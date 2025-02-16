# Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.product}-adgroup-admin"
}

#
# Network
#
data "azurerm_virtual_network" "vnet_platform" {
  name                = local.vnet_core_platform_name
  resource_group_name = local.vnet_rg_name
}


# ### Log Analytics
# data "azurerm_log_analytics_workspace" "log_analytics" {
#   name                = local.log_analytics_workspace_name
#   resource_group_name = local.monitor_resource_group_name
# }
