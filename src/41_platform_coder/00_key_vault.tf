#
# KeyVault
#
data "azurerm_key_vault" "key_vault_domain" {
  name                = local.kv_core_name
  resource_group_name = local.kv_core_resource_group_name
}

# Start Postgres
# KV secrets flex server
data "azurerm_key_vault_secret" "pgres_flex_admin_login" {
  name         = "pgres-flex-admin-login"
  key_vault_id = data.azurerm_key_vault.key_vault_domain.id
}

data "azurerm_key_vault_secret" "pgres_flex_admin_pwd" {
  name         = "pgres-flex-admin-pwd"
  key_vault_id = data.azurerm_key_vault.key_vault_domain.id
}
