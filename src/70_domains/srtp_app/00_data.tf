data "azurerm_subscription" "current" {}
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

data "azurerm_storage_account" "rtp_jks_storage_account" {
  name                = replace(local.srtp-jks-storage-account-name, "-", "")
  resource_group_name = local.data_rg
}


# APIM
data "azurerm_api_management" "apim" {
  name                = local.apim_name
  resource_group_name = local.apim_rg_name
}

### Identity
data "azurerm_key_vault_secret" "workload_identity_client_id" {
  name         = local.secret_name_workload_identity_client_id
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

data "azurerm_key_vault_secret" "workload_identity_service_account_name" {
  name         = local.secret_name_workload_identity_service_account_name
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

data "azurerm_user_assigned_identity" "workload_identity_aks" {
  name                = local.secret_name_workload_identity
  resource_group_name = local.aks_resource_group_name
}

### ARGO
data "azurerm_key_vault_secret" "argocd_admin_username" {
  name         = "argocd-admin-username"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

data "azurerm_key_vault_secret" "argocd_admin_password" {
  name         = "argocd-admin-password"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}
