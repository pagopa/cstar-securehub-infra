data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "github_team" "admin" {
  slug = "idpay-approver-team"
}

data "azurerm_key_vault" "core_cicd" {
  name                = "${var.prefix}-${var.env_short}-${var.location_short}-cicd-kv"
  resource_group_name = "${var.prefix}-${var.env_short}-${var.location_short}-core-sec-rg"
}

data "azurerm_key_vault_secret" "sonar_token" {
  key_vault_id = data.azurerm_key_vault.core_cicd.id
  name         = "sonar-token"
}

data "azurerm_key_vault" "idpay" {
  name                = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}-kv"
  resource_group_name = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}-security-rg"
}

data "azurerm_key_vault_secret" "gh_token" {
  key_vault_id = data.azurerm_key_vault.idpay.id
  name         = "idpay-bot-github-self-hosted-runners-TOKEN"
}
