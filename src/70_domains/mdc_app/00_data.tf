# 🔒 Key Vault
data "azurerm_key_vault" "kv_domain" {
  name                = local.kv_domain_name
  resource_group_name = local.kv_domain_rg_name
}

# 📥 Event Hub Namespace (read-only)
data "azurerm_eventhub_namespace" "eventhub" {
  name                = local.eventhub_namespace_name
  resource_group_name = local.eventhub_namespace_rg_name
}

data "azurerm_application_insights" "application_insights" {
  name                = local.monitor_appinsights_name
  resource_group_name = local.monitor_resource_group_name
}

# 🐳 Kubernetes Cluster
data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = local.aks_resource_group_name
}

# 🔗 API Management
data "azurerm_api_management" "apim_core" {
  name                = local.apim_name
  resource_group_name = local.apim_rg_name
}

# 🔑 Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.product}-adgroup-admin"
}

data "azuread_group" "adgroup_developers" {
  display_name = "${local.product}-adgroup-developers"
}

data "azuread_group" "adgroup_externals" {
  display_name = "${local.product}-adgroup-externals"
}

data "azuread_group" "adgroup_security" {
  display_name = "${local.product}-adgroup-security"
}

### ARGO
data "azurerm_key_vault_secret" "argocd_admin_username" {
  name         = "argocd-admin-username"
  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

data "azurerm_key_vault_secret" "argocd_admin_password" {
  name         = "argocd-admin-password"
  key_vault_id = data.azurerm_key_vault.kv_domain.id
}
