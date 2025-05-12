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
  name                = local.vnet_weu_core.name
  resource_group_name = local.vnet_weu_core.resource_group
}

data "azurerm_virtual_network" "vnet_weu_integration" {
  name                = local.vnet_weu_integration.name
  resource_group_name = local.vnet_weu_integration.resource_group
}

data "azurerm_virtual_network" "vnet_weu_aks" {
  name                = local.vnet_weu_aks.name
  resource_group_name = local.vnet_weu_aks.resource_group
}

#
# Packer
#
data "azurerm_resource_group" "rg_packer" {
  name     = local.packer_rg_name
}
