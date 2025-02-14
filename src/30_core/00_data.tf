#
# 🔐 KV
#
data "azurerm_resource_group" "sec_rg" {
  name = "${local.project}-sec-rg"
}

data "azurerm_key_vault" "core_kvs" {

  for_each = toset(local.core_kv_prefix_names)

  name                = "${local.product}-${each.key}-kv"
  resource_group_name = local.rg_name_core_security
}

#
# 🌐 Networking
#

data "azurerm_subnet" "azdoa_snet" {
  name                 = "${local.project}-hub-azdoa-snet"
  resource_group_name  = local.vnet_hub_resource_group_name
  virtual_network_name = local.vnet_hub_name
}

#
# Managed identity
#
data "azurerm_user_assigned_identity" "iac_federated_azdo" {
  for_each            = local.azdo_iac_managed_identities
  name                = each.key
  resource_group_name = local.legacy_managed_identity_resource_group_name
}

#
# Packer
#
data "azurerm_resource_group" "packer_rg" {
  name = local.packer_rg_name
}
