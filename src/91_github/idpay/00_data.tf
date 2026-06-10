data "github_team" "admin" {
  slug = "idpay-approver-team"
}

data "azurerm_key_vault" "core_cicd_for_prod" {
  name                = "cstar-p-itn-cicd-kv"
  resource_group_name = "cstar-p-itn-core-sec-rg"
}

data "azurerm_key_vault" "uat_core_cicd_for_uat" {
  name                = "cstar-u-itn-cicd-kv"
  resource_group_name = "cstar-u-itn-core-sec-rg"
  provider            = azurerm.uat
}

data "azurerm_key_vault_secret" "sonar_token" {
  key_vault_id = data.azurerm_key_vault.core_cicd_for_prod.id
  name         = "sonar-token"
}

data "azurerm_key_vault_secret" "argocd_admin_username_for_prod" {
  key_vault_id = data.azurerm_key_vault.core_cicd_for_prod.id
  name         = "argocd-admin-username"
}

data "azurerm_key_vault_secret" "argocd_admin_password_for_prod" {
  key_vault_id = data.azurerm_key_vault.core_cicd_for_prod.id
  name         = "argocd-admin-password"
}

data "azurerm_key_vault_secret" "argocd_admin_username_for_uat" {
  key_vault_id = data.azurerm_key_vault.uat_core_cicd_for_uat.id
  name         = "argocd-admin-username"
}

data "azurerm_key_vault_secret" "argocd_admin_password_for_uat" {
  key_vault_id = data.azurerm_key_vault.uat_core_cicd_for_uat.id
  name         = "argocd-admin-password"
}