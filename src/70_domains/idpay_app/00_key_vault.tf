#
# KeyVault
#
data "azurerm_key_vault" "key_vault_domain" {
  name                = local.idpay_kv_name
  resource_group_name = local.idpay_kv_rg_name
}

### ARGO
data "azurerm_key_vault_secret" "argocd_admin_username" {
  name         = "argocd-admin-username"
  key_vault_id = data.azurerm_key_vault.key_vault_domain.id
}

data "azurerm_key_vault_secret" "argocd_admin_password" {
  name         = "argocd-admin-password"
  key_vault_id = data.azurerm_key_vault.key_vault_domain.id
}

### WORKLOAD
data "azurerm_key_vault_secret" "workload_identity_client_id" {
  name         = "idpay-workload-identity-client-id"
  key_vault_id = data.azurerm_key_vault.key_vault_domain.id
}

data "azurerm_key_vault_secret" "workload_identity_service_account_name" {
  name         = "idpay-workload-identity-service-account-name"
  key_vault_id = data.azurerm_key_vault.key_vault_domain.id
}


# data "azurerm_key_vault" "kv" {
#   name                = "${local.product}-${var.domain}-kv"
#   resource_group_name = "${local.product}-${var.domain}-sec-rg"
# }
#
#
# resource "azurerm_key_vault_access_policy" "apim" {
#   key_vault_id = data.azurerm_key_vault.kv.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = data.azurerm_api_management.apim_core.identity[0].principal_id
#
#   key_permissions = [
#     "Get",
#   ]
#
#   secret_permissions = [
#     "Get",
#     "List",
#   ]
# }
#
# data "azurerm_key_vault" "kv_cstar" {
#   name                = "${local.product}-kv"
#   resource_group_name = "${local.product}-sec-rg"
# }
