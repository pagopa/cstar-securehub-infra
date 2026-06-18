data "github_team" "admin" {
  slug = "emd-team-admin"
}

data "azurerm_key_vault" "mdc" {
  name                = var.mdc_kv_name
  resource_group_name = var.mdc_kv_rg
}

data "azurerm_key_vault_secret" "sonar_token" {
  key_vault_id = data.azurerm_key_vault.mdc.id
  name         = "sonar-token"
}

data "azurerm_key_vault_secret" "emd-bot-github-rw-token" {
  key_vault_id = data.azurerm_key_vault.mdc.id
  name         = "emd-bot-github-rw-TOKEN"
}

data "azurerm_key_vault_secret" "mil-gh-bot-token" {
  key_vault_id = data.azurerm_key_vault.mdc.id
  name         = "mil-gh-bot-token"
}

data "azurerm_key_vault_secret" "argo_cd_username" {
  key_vault_id = data.azurerm_key_vault.mdc.id
  name         = "argocd-admin-username"
}

data "azurerm_key_vault_secret" "argo_cd_password" {
  key_vault_id = data.azurerm_key_vault.mdc.id
  name         = "argocd-admin-password"
}