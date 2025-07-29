
# See https://github.com/keycloak/terraform-provider-keycloak/blob/main/example/main.tf
resource "keycloak_realm" "merchant_operator" {
  realm        = "merchant-operator"
  enabled      = true
  display_name = "merchant-operator"

  login_theme = "pagopa"

  smtp_server {
    host = data.azurerm_key_vault_secret.ses_smtp_host.value
    port = local.ses_smtp_port
    from = data.azurerm_key_vault_secret.ses_from_address.value
    ssl  = true

    auth {
      username = data.azurerm_key_vault_secret.ses_smtp_username.value
      password = data.azurerm_key_vault_secret.ses_smtp_password.value
    }
  }
}

resource "keycloak_openid_client" "merchant_operator_frontend" {
  realm_id  = keycloak_realm.merchant_operator.id
  client_id = "frontend"
  name      = "Merchant Operator Frontend"
  enabled   = true

  access_type = "PUBLIC"

  standard_flow_enabled = true

  web_origins = flatten([
    [
      local.keycloak_external_hostname,
      "http://localhost:5173",
  ], formatlist("https://%s", local.public_dns_zone_bonus_elettrodomestici.zones)])

  valid_redirect_uris = flatten([
    [
      "${local.keycloak_external_hostname}/*",
      "http://localhost:5173/*",
  ], formatlist("https://%s/*", local.public_dns_zone_bonus_elettrodomestici.zones)])

  depends_on = [
    keycloak_realm.merchant_operator,
  ]
}

# User
resource "keycloak_realm" "user" {
  realm        = "user"
  enabled      = true
  display_name = "user"
}

resource "keycloak_openid_client" "user_frontend" {
  realm_id  = keycloak_realm.user.id
  client_id = "frontend"
  name      = "Portal User Frontend"
  enabled   = true

  access_type = "PUBLIC"

  standard_flow_enabled = true

  web_origins = flatten([
    [
      local.keycloak_external_hostname,
      "http://localhost:5173",
  ], formatlist("https://%s", local.public_dns_zone_bonus_elettrodomestici.zones)])

  valid_redirect_uris = flatten([
    [
      "${local.keycloak_external_hostname}/*",
      "http://localhost:5173/*",
  ], formatlist("https://%s/*", local.public_dns_zone_bonus_elettrodomestici.zones)])

  depends_on = [
    keycloak_realm.user,
  ]
}

resource "keycloak_oidc_identity_provider" "one_identity_provider" {
  realm             = keycloak_realm.user.id
  alias             = "oneid-keycloak"
  display_name      = "OneIdentity"
  authorization_url = "${local.one_identity_base_url}/login"
  token_url         = "${local.one_identity_base_url}/oidc/token"
  client_id         = data.azurerm_key_vault_secret.one_identity_pagopa_client.value
  client_secret     = data.azurerm_key_vault_secret.one_identity_pagopa_client_secret.value
  issuer            = local.one_identity_base_url
  trust_email       = true
  store_token       = true
  stored_tokens_readable = true
  sync_mode         = "LEGACY"
  validate_signature = false
  backchannel_supported = false
  default_scopes    = "openid email profile"

  extra_config = {
    "clientAuthMethod" = "client_secret_basic"
  }
}

resource "keycloak_identity_provider_mapper" "first_name_mapper" {
  realm                    = keycloak_realm.user.id
  identity_provider_alias  = keycloak_oidc_identity_provider.one_identity_provider.alias
  name                     = "firstName-mapper"
  identity_provider_mapper = "oidc-user-attribute-idp-mapper"

  extra_config = {
    "claim"             = "name"
    "user.attribute"    = "firstName"
  }
}

resource "keycloak_identity_provider_mapper" "last_name_mapper" {
  realm                    = keycloak_realm.user.id
  identity_provider_alias  = keycloak_oidc_identity_provider.one_identity_provider.alias
  name                     = "lastName-mapper"
  identity_provider_mapper = "oidc-user-attribute-idp-mapper"

  extra_config = {
    "claim"             = "familyName"
    "user.attribute"    = "lastName"
  }
}

resource "keycloak_identity_provider_mapper" "username_mapper" {
  realm                    = keycloak_realm.user.id
  identity_provider_alias  = keycloak_oidc_identity_provider.one_identity_provider.alias
  name                     = "username-mapper"
  identity_provider_mapper = "oidc-user-username-idp-mapper"

  extra_config = {
    "template" = "${CLAIM.email}"
    "target"   = "BROKER_ID"
  }
}

resource "keycloak_identity_provider_mapper" "email_mapper" {
  realm                    = keycloak_realm.user.id
  identity_provider_alias  = keycloak_oidc_identity_provider.one_identity_provider.alias
  name                     = "email-mapper"
  identity_provider_mapper = "oidc-user-attribute-idp-mapper"

  extra_config = {
    "claim"          = "email"
    "user.attribute" = "email"
  }
}
