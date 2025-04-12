#
# Azure Resource Groups
#
data "azurerm_resource_group" "idpay_data_rg" {
  name = "${local.project}-data-rg"
}

#
# 🌐 Network
#
data "azurerm_virtual_network" "vnet_spoke_data" {
  name                = local.vnet_spoke_data_name
  resource_group_name = local.vnet_spoke_data_rg_name
}

# Cosmos MongoDB private dns zone
data "azurerm_private_dns_zone" "cosmos_mongo" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = local.vnet_core_rg_name
}

# Eventhub private dns zone
data "azurerm_private_dns_zone" "eventhub" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = local.vnet_core_rg_name
}

# Redis private dns zone
data "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = local.vnet_core_rg_name
}

#
# KeyVault
#
data "azurerm_key_vault" "idpay_kv" {
  name                = local.idpay_kv_name
  resource_group_name = local.idpay_kv_rg_name
}
