data "azurerm_key_vault_secret" "azure_ad_secret" {
  name         = "keycloak-url"
  key_vault_id = data.azurerm_key_vault.core_kv.id
}

resource "keycloak_oidc_identity_provider" "azure_ad" {
  realm             = keycloak_realm.merchant_operator.id
  alias             = "azure-ad"
  display_name      = "Microsoft Entra ID"
  enabled           = true
  authorization_url = "https://login.microsoftonline.com/${tenant_id}/oauth2/v2.0/authorize"
  token_url        = "https://login.microsoftonline.com/${tenant_id}/oauth2/v2.0/token"
  client_id              = var.azure_ad_client_id
  client_secret          = data.azurerm_key_vault_secret.azure_ad_secret.value

  sync_mode = "FORCE"
}

data "keycloak_role" "realm_admin" {
  realm     = "master"
  client_id = "realm-management"
  name      = "realm-admin"
}

# 2. Creiamo il Mapper per l'Identity Provider Azure
resource "keycloak_oidc_group_to_role_identity_provider_mapper" "azure_admin_mapper" {
  realm                   = "esercenti"
  identity_provider_alias = keycloak_oidc_identity_provider.azure_ad.alias
  name                    = "azure-admin-group-mapper"

  # Il nome del claim che arriva da Azure (configurato al punto 1)
  claim_name              = "groups"

  # L'Object ID del gruppo su Azure Entra ID
  claim_value             = "00000000-0000-0000-0000-000000000000" # ID del gruppo "Team_Esercenti_Admins"

  # Il ruolo di Keycloak da assegnare se il claim corrisponde
  role                    = data.keycloak_role.realm_admin.name
}
