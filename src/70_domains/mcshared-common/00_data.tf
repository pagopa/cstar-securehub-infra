data "azurerm_subscription" "current" {}
#
# Private DNS Zones
#
#
# Cosmos MongoDB private dns zone
data "azurerm_private_dns_zone" "cosmos_mongo" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = local.vnet_core_rg_name
}

data "azurerm_private_dns_zone" "container_app" {
  name                = "privatelink.${var.location}.azurecontainerapps.io"
  resource_group_name = local.network_rg
}

#
# KeyVault
#
data "azurerm_key_vault" "domain_general_kv" {
  name                = local.general_kv_name
  resource_group_name = local.security_rg_name
}

data "azurerm_key_vault" "auth_general_kv" {
  name                = local.auth_kv_name
  resource_group_name = local.security_rg_name
}

#
# APIM
#

data "azurerm_api_management" "apim" {
  name                = local.apim_name
  resource_group_name = local.apim_rg_name
}

#
# AZDO
#
data "azurerm_user_assigned_identity" "iac_federated_azdo" {
  for_each = local.azdo_iac_managed_identities

  name                = each.key
  resource_group_name = local.azdo_managed_identity_rg_name
}
