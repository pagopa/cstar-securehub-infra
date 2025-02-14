#
# 🔐 KV
#

data "azurerm_key_vault" "key_vault" {
  name                = "${local.project}-kv"
  resource_group_name = local.rg_name_core_security
}

#
# 🌐 Networking
#

data "azurerm_subnet" "azdoa_snet" {
  name                 = "${local.project}-azdoa-snet"
  resource_group_name  = local.vnet_resource_group_name
  virtual_network_name = local.vnet_name
}

#
# Resource Group
#

data "azurerm_resource_group" "sec_rg" {
  name = "${local.project}-sec-rg"
}

data "azurerm_resource_group" "packer_rg" {
  name = "${local.product}-${var.location_short}-packer-azdoa-rg"
}

#
# Managed identity
#
data "azurerm_user_assigned_identity" "iac_federated_azdo" {
  for_each            = local.azdo_iac_managed_identities
  name                = each.key
  resource_group_name = local.azdo_managed_identity_rg_name
}
