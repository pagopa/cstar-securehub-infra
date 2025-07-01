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

#
# Storage Account
#
data "azurerm_storage_account" "rtp_storage_account" {
  name                = replace(local.srtp_storage_account_name, "-", "")
  resource_group_name = local.data_rg
}

#---------------------------------------------------------------------
# APIM
#---------------------------------------------------------------------
data "azurerm_api_management" "apim" {
  name                = local.apim_name
  resource_group_name = local.apim_rg_name
}
