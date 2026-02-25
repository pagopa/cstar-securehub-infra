data "azuread_application" "keycloak" {
  display_name = "${var.prefix}-${var.env}-keycloak"
}

resource "keycloak_custom_identity_provider_mapper" "azure_username_mapper" {
  for_each = { for i in [keycloak_oidc_identity_provider.hub_spoke_oidc, keycloak_oidc_identity_provider.master_admin] : i.realm => i }

  realm                    = each.key
  name                     = "azure-username-mapper"
  identity_provider_alias  = each.value.alias
  identity_provider_mapper = "oidc-username-idp-mapper"

  extra_config = {
    syncMode = "INHERIT"
    template = "$${CLAIM.preferred_username}"
  }
}

resource "keycloak_custom_identity_provider_mapper" "azure_first_name" {
  for_each = { for i in [keycloak_oidc_identity_provider.hub_spoke_oidc, keycloak_oidc_identity_provider.master_admin] : i.realm => i }

  realm                    = each.key
  name                     = "azure-firstname-mapper"
  identity_provider_alias  = each.value.alias
  identity_provider_mapper = "oidc-user-attribute-idp-mapper"

  extra_config = {
    syncMode         = "INHERIT"
    claim            = "given_name"
    "user.attribute" = "firstName"
  }
}

resource "keycloak_custom_identity_provider_mapper" "azure_last_name" {
  for_each = { for i in [keycloak_oidc_identity_provider.hub_spoke_oidc, keycloak_oidc_identity_provider.master_admin] : i.realm => i }

  realm                    = each.key
  name                     = "azure-lastname-mapper"
  identity_provider_alias  = each.value.alias
  identity_provider_mapper = "oidc-user-attribute-idp-mapper"

  extra_config = {
    syncMode         = "INHERIT"
    claim            = "family_name"
    "user.attribute" = "lastName"
  }
}

resource "keycloak_custom_identity_provider_mapper" "azure_email" {
  for_each = { for i in [keycloak_oidc_identity_provider.hub_spoke_oidc, keycloak_oidc_identity_provider.master_admin] : i.realm => i }

  realm                    = each.key
  name                     = "azure-email-mapper"
  identity_provider_alias  = each.value.alias
  identity_provider_mapper = "oidc-user-attribute-idp-mapper"

  extra_config = {
    syncMode         = "INHERIT"
    claim            = "preferred_username"
    "user.attribute" = "email"
  }
}
