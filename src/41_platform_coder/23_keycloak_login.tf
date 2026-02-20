data "azurerm_key_vault_secret" "azure_ad_secret" {
  name         = "keycloak-url"
  key_vault_id = data.azurerm_key_vault.key_vault_core.id
}

resource "keycloak_oidc_identity_provider" "azure_ad" {
  realm             = "master"
  alias             = "azure-ad"
  display_name      = "Microsoft Entra ID"
  enabled           = true
  authorization_url = "https://login.microsoftonline.com/${tenant_id}/oauth2/v2.0/authorize"
  token_url         = "https://login.microsoftonline.com/${tenant_id}/oauth2/v2.0/token"
  client_id              = var.azure_ad_client_id
  client_secret          = data.azurerm_key_vault_secret.azure_ad_secret.value

  sync_mode = "FORCE"
}
