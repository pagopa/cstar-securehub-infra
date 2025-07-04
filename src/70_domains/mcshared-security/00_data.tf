data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

#
# 🌐 Network
#
data "azurerm_virtual_network" "vnet_spoke_security" {
  name                = local.vnet_spoke_security_name
  resource_group_name = local.vnet_core_rg_name
}

# 🔎 DNS
data "azurerm_private_dns_zone" "key_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = local.vnet_legacy_core_rg
}


# Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.product}-adgroup-admin"
}

data "azuread_group" "adgroup_developers" {
  display_name = "${local.product}-adgroup-developers"
}

data "azuread_group" "adgroup_externals" {
  display_name = "${local.product}-adgroup-externals"
}
