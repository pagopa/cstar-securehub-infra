# KV
data "azurerm_key_vault" "kv_core" {
  name                = "${local.product}-${var.location_short}-core-kv"
  resource_group_name = "${local.product}-${var.location_short}-core-sec-rg"
}

data "azurerm_key_vault_secret" "slack_mail_alarm" {
  name         = "monitor-notification-slack-email"
  key_vault_id = data.azurerm_key_vault.kv_core.id
}
