# 🔐 KV
data "azurerm_key_vault" "domain_kv" {
  name                = local.key_vault_name
  resource_group_name = local.key_vault_rg_name
}

#
# RG
#
data "azurerm_resource_group" "identities_rg" {
  name = local.identities_rg
}
