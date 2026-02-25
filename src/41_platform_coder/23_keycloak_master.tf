# ----------------------------------------------------------------------------
# MASTER REALM OIDC: GLOBAL ADMINISTRATORS ONLY
#
# This Identity Provider is strictly dedicated to infrastructure administrators.
# It allows authorized users (via Azure AD group mapping) to log into the
# 'master' realm and inherit the global 'admin' role. This grants them full
# control over the entire Keycloak instance, including the ability to create,
# manage, and delete other project realms.
# End-users should NEVER authenticate through this Identity Provider
# ----------------------------------------------------------------------------
resource "keycloak_oidc_identity_provider" "master_admin" {
  realm             = "master"
  alias             = "azure-entra"
  display_name      = "Microsoft Entra ID (Admin Access)"
  enabled           = true
  authorization_url = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/oauth2/v2.0/authorize"
  token_url         = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/oauth2/v2.0/token"

  client_id      = data.azuread_application.keycloak.client_id
  client_secret  = module.core_secrets.values["keycloak-azure-app-secret-value"].value
  default_scopes = "openid profile email"

  sync_mode   = "FORCE"
  trust_email = true
}

resource "keycloak_custom_identity_provider_mapper" "azure_admin_mapper_master" {
  realm                    = "master"
  name                     = "azure-group-to-global-admin"
  identity_provider_alias  = keycloak_oidc_identity_provider.master_admin.alias
  identity_provider_mapper = "oidc-role-idp-mapper"

  extra_config = {
    syncMode      = "FORCE"
    claim         = "groups"
    "claim.value" = data.azuread_group.adgroup_admin.object_id
    role          = "admin"
  }
}
