resource "azurerm_key_vault_secret" "appinisights_connection_string_kv" {
  name         = "appinsights-connection-string"
  value        = azurerm_application_insights.srtp_application_insights.connection_string
  key_vault_id = data.azurerm_key_vault.domain_kv.id
  tags         = module.tag_config.tags
}
