#
# 🔐 KV
#
data "azurerm_key_vault" "kv_core" {
  name                = local.kv_core_name
  resource_group_name = local.kv_core_resource_group_name
}

#
# Vnet Legacy
#
data "azurerm_virtual_network" "vnet_weu_core" {
  name                = "${var.prefix}-${var.env_short}-vnet"
  resource_group_name = "${var.prefix}-${var.env_short}-vnet-rg"
}

data "azurerm_virtual_network" "vnet_weu_integration" {
  name                = "${var.prefix}-${var.env_short}-integration-vnet"
  resource_group_name = "${var.prefix}-${var.env_short}-vnet-rg"
}

data "azurerm_virtual_network" "vnet_weu_aks" {
  name                = "${var.prefix}-${var.env_short}-weu-${var.env}01-vnet"
  resource_group_name = "${var.prefix}-${var.env_short}-weu-${var.env}01-vnet-rg"
}

#
# Dns Zone
#

data "azurerm_dns_zone" "default" {
  name                = local.dns_default_zone_name
  resource_group_name = local.dns_default_zone_rg
}
