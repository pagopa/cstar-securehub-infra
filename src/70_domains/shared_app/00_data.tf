data "azurerm_subscription" "current" {}

# 🔐 KV
data "azurerm_key_vault" "domain_kv" {
  name                = local.key_vault_name
  resource_group_name = local.key_vault_rg_name
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

### ARGO
data "azurerm_key_vault_secret" "argocd_admin_username" {
  name         = "argocd-admin-username"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

data "azurerm_key_vault_secret" "argocd_admin_password" {
  name         = "argocd-admin-password"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}
