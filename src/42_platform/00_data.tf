#
# Network
#
data "azurerm_virtual_network" "vnet_core" {
  name                = "${local.product_core}-vnet"
  resource_group_name = "${local.product_core}-vnet-rg"
}

data "azurerm_private_dns_zone" "postgres" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = data.azurerm_virtual_network.vnet_core.resource_group_name
}

data "azurerm_private_dns_zone" "internal" {
  name                = local.internal_dns_zone_name
  resource_group_name = local.internal_dns_zone_resource_group_name
}

#
# 🔒 KV
#
data "azurerm_key_vault" "key_vault_core" {
  name                = "${local.product_core}-kv"
  resource_group_name = local.rg_name_core_security
}

#
# Monitor
#
data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = local.log_analytics_workspace_name
  resource_group_name = local.monitor_resource_group_name
}

#
# AKS
#
data "azurerm_kubernetes_cluster" "this" {
  name                = "${local.product}-${var.location_short}-${var.env}-aks"
  resource_group_name = "${local.product}-${var.location_short}-${var.env}-aks-rg"
}
