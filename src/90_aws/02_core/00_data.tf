# KV
data "azurerm_key_vault" "kv_core" {
  name                = "${local.product}-kv"
  resource_group_name = "${var.prefix}-${var.env_short}-sec-rg"
}

data "azurerm_key_vault_secret" "slack_mail_alarm" {
  name         = "alert-error-notification-slack"
  key_vault_id = data.azurerm_key_vault.kv_core.id
}
