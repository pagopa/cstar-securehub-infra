# Azure Entra
data "azuread_group" "adgroup_admin" {
  display_name = "${local.product}-adgroup-admin"
}

data "azuread_group" "adgroup_developers" {
  display_name = "${local.product}-adgroup-developers"
}

#
# Network
#
data "azurerm_virtual_network" "vnet_hub" {
  name                = local.vnet_core_hub_name
  resource_group_name = local.vnet_rg_name
}

data "azurerm_private_dns_zone" "storage_account_table" {
  name                = local.dns_privatelink_storage_table
  resource_group_name = local.legacy_vnet_core_rg_name
}

#
# 🔐 KV
#

# CICD
data "azurerm_key_vault" "cicd_kv" {
  name                = local.kv_cicd_name
  resource_group_name = local.kv_cicd_resource_group_name
}

# CORE
data "azurerm_key_vault" "core_kv" {
  name                = local.kv_core_name
  resource_group_name = local.kv_core_resource_group_name
}

# Secrets
data "azurerm_key_vault_secret" "email_google_cstar_status" {
  name         = "email-google-group-cstar-status"
  key_vault_id = data.azurerm_key_vault.cicd_kv.id
}

data "azurerm_key_vault_secret" "email_slack_cstar_status" {
  name         = "email-slack-cstar-status"
  key_vault_id = data.azurerm_key_vault.cicd_kv.id
}
