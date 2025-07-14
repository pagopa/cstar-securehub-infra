data "azurerm_subscription" "current" {}

# 🔐 KV
data "azurerm_key_vault" "domain_kv" {
  name                = local.key_vault_name
  resource_group_name = local.key_vault_rg_name
}

#
# RG
#
data "azurerm_resource_group" "srtp_monitoring_rg" {
  name = local.monitor_rg_name
}

data "azurerm_resource_group" "compute_rg" {
  name = local.compute_rg_name
}

#
# Network
#
data "azurerm_nat_gateway" "compute_nat_gateway" {
  name                = "${local.project_core}-compute-natgw"
  resource_group_name = local.network_rg
}

# 🔎 DNS
data "azurerm_private_dns_zone" "cosmos_mongo" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = local.vnet_legacy_core_rg
}

data "azurerm_private_dns_zone" "blob_storage" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = local.vnet_legacy_core_rg
}

data "azurerm_private_dns_zone" "file_storage" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = local.network_rg
}

data "azurerm_private_dns_zone" "container_apps" {
  name                = "privatelink.${var.location}.azurecontainerapps.io"
  resource_group_name = local.network_rg
}

#
# APIM
#

data "azurerm_api_management" "apim" {
  name                = local.apim_name
  resource_group_name = local.apim_rg_name
}
