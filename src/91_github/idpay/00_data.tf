data "github_team" "admin" {
  slug = "idpay-approver-team"
}

data "azurerm_key_vault" "cicd" {
  name                = var.cicd_kv_name
  resource_group_name = var.cicd_kv_rg
}

data "azurerm_key_vault_secret" "sonar_token" {
  key_vault_id = data.azurerm_key_vault.cicd.id
  name         = "sonar-token"
}

data "azurerm_key_vault_secret" "argo_cd_username" {
  key_vault_id = data.azurerm_key_vault.cicd.id
  name         = "argocd-admin-username"
}

data "azurerm_key_vault_secret" "argo_cd_password" {
  key_vault_id = data.azurerm_key_vault.cicd.id
  name         = "argocd-admin-password"
}
