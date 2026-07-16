data "github_team" "admin" {
  slug = "idpay-approver-team"
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

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

data "azurerm_key_vault" "idpay" {
  name                = var.idpay_kv_name
  resource_group_name = var.idpay_kv_rg
}

data "azurerm_key_vault_secret" "gh_token" {
  key_vault_id = data.azurerm_key_vault.idpay.id
  name         = "idpay-bot-github-self-hosted-runners-TOKEN"
}

data "azurerm_key_vault_secret" "workload_identity_client_id" {
  key_vault_id = data.azurerm_key_vault.idpay.id
  name         = local.secret_name_idpay_workload_identity_client_id
}
