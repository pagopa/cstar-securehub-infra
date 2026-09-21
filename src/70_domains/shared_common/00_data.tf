data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

# Azure Kubernetes Service
data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = local.aks_resource_group_name
}

# 🔐 KV
data "azurerm_key_vault" "domain_kv" {
  name                = local.key_vault_name
  resource_group_name = local.key_vault_rg_name
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

#
# APIM
#

data "azurerm_api_management" "apim" {
  name                = local.apim_name
  resource_group_name = local.apim_rg_name
}
