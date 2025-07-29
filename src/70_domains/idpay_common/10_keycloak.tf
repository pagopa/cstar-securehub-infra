
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
  realm                 = keycloak_realm.user.id
  alias                 = "oneid-keycloak"
  display_name          = "OneIdentity"
  authorization_url     = "${local.one_identity_base_url}/login"
  token_url             = "${local.one_identity_base_url}/oidc/token"
  client_id             = data.azurerm_key_vault_secret.oneidentity-client-id.value
  client_secret         = data.azurerm_key_vault_secret.oneidentity-client-secret.value
  issuer                = local.one_identity_base_url
  trust_email           = true
  store_token           = true
  sync_mode             = "LEGACY"
  validate_signature    = false
  backchannel_supported = false

  extra_config = {
    "clientAuthMethod" = "client_secret_basic"
  }
}

resource "keycloak_attribute_importer_identity_provider_mapper" "first_name_mapper" {
  realm                   = keycloak_realm.user.id
  name                    = "first_name_mapper"
  claim_name              = "name"
  identity_provider_alias = keycloak_oidc_identity_provider.one_identity_provider.alias
  user_attribute          = "firstName"

  # extra_config with syncMode is required in Keycloak 10+
  extra_config = {
    syncMode = "INHERIT"
  }
}

resource "keycloak_attribute_importer_identity_provider_mapper" "last_name_mapper" {
  realm                   = keycloak_realm.user.id
  name                    = "last_name_mapper"
  claim_name              = "familyName"
  identity_provider_alias = keycloak_oidc_identity_provider.one_identity_provider.alias
  user_attribute          = "lastName"

  # extra_config with syncMode is required in Keycloak 10+
  extra_config = {
    syncMode = "INHERIT"
  }
}



resource "keycloak_user_template_importer_identity_provider_mapper" "username_mapper" {
  realm                   = keycloak_realm.user.id
  name                    = "username-mapper"
  identity_provider_alias = keycloak_oidc_identity_provider.one_identity_provider.alias
  template                = "$${CLAIM.email}"

  # extra_config with syncMode is required in Keycloak 10+
  extra_config = {
    syncMode = "INHERIT"
    target   = "BROKER_ID"
  }
}

resource "keycloak_attribute_importer_identity_provider_mapper" "email_mapper" {
  realm                   = keycloak_realm.user.id
  name                    = "email-mapper"
  claim_name              = "email"
  identity_provider_alias = keycloak_oidc_identity_provider.one_identity_provider.alias
  user_attribute          = "email"

  # extra_config with syncMode is required in Keycloak 10+
  extra_config = {
    syncMode = "INHERIT"
  }
}
