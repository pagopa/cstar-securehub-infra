resource "azurerm_key_vault_secret" "appinisights_connection_string_kv" {
  name         = "appinsights-connection-string"
  value        = data.azurerm_application_insights.appinsights.connection_string
  key_vault_id = data.azurerm_key_vault.domain_kv.id
  tags         = module.tag_config.tags
}
