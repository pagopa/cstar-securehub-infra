data "azurerm_key_vault" "core_cicd" {
  name                = "${var.prefix}-${var.env_short}-${var.location_short}-cicd-kv"
  resource_group_name = "${var.prefix}-${var.env_short}-${var.location_short}-core-sec-rg"
}

data "azurerm_key_vault_secret" "sonar_token" {
  key_vault_id = data.azurerm_key_vault.core_cicd.id
  name         = "aws-${var.prefix}-sonar-token"
}
