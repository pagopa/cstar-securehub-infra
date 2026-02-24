data "azuread_application" "keycloak" {
  display_name = "${var.prefix}-${var.env}-keycloak"
}

resource "keycloak_oidc_identity_provider" "azure_ad" {
  realm             = "master"
  alias             = "azure-entra"
  display_name      = "Microsoft Entra ID"
  enabled           = true
  authorization_url = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/oauth2/v2.0/authorize"
  token_url         = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/oauth2/v2.0/token"

  client_id      = data.azuread_application.keycloak.client_id
  client_secret  = module.core_secrets.values["keycloak-azure-app-secret-value"].value
  default_scopes = "openid profile email"

  sync_mode   = "FORCE"
  trust_email = true
}

resource "keycloak_custom_identity_provider_mapper" "azure_admin_mapper" {
  realm                    = "master"
  name                     = "azure-group-to-admin"
  identity_provider_alias  = keycloak_oidc_identity_provider.azure_ad.alias
  identity_provider_mapper = "oidc-role-idp-mapper"

  extra_config = {
    syncMode      = "FORCE"
    claim         = "groups"
    "claim.value" = data.azuread_group.adgroup_admin.object_id
    role          = "admin"
  }
}

resource "keycloak_custom_identity_provider_mapper" "azure_username_mapper" {
  realm                    = "master"
  name                     = "azure-username-mapper"
  identity_provider_alias  = keycloak_oidc_identity_provider.azure_ad.alias
  identity_provider_mapper = "oidc-username-idp-mapper"

  extra_config = {
    syncMode = "INHERIT"
    template = "$${CLAIM.preferred_username}"
  }
}

resource "keycloak_custom_identity_provider_mapper" "azure_first_name" {
  realm                    = "master"
  name                     = "azure-firstname-mapper"
  identity_provider_alias  = keycloak_oidc_identity_provider.azure_ad.alias
  identity_provider_mapper = "oidc-user-attribute-idp-mapper"

  extra_config = {
    syncMode         = "INHERIT"
    claim            = "given_name"
    "user.attribute" = "firstName"
  }
}

resource "keycloak_custom_identity_provider_mapper" "azure_last_name" {
  realm                    = "master"
  name                     = "azure-lastname-mapper"
  identity_provider_alias  = keycloak_oidc_identity_provider.azure_ad.alias
  identity_provider_mapper = "oidc-user-attribute-idp-mapper"

  extra_config = {
    syncMode         = "INHERIT"
    claim            = "family_name"
    "user.attribute" = "lastName"
  }
}

resource "keycloak_custom_identity_provider_mapper" "azure_email" {
  realm                    = "master"
  name                     = "azure-email-mapper"
  identity_provider_alias  = keycloak_oidc_identity_provider.azure_ad.alias
  identity_provider_mapper = "oidc-user-attribute-idp-mapper"

  extra_config = {
    syncMode         = "INHERIT"
    claim            = "preferred_username"
    "user.attribute" = "email"
  }
}
