
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

#$ terraform import keycloak_oidc_identity_provider.realm_identity_provider my-realm/my-idp
resource "keycloak_oidc_identity_provider" "one_identity_provider" {
  realm             = keycloak_realm.user.id
  alias             = "oneid-keycloak"
  display_name      = "OneIdentity"
  #TODO TBV
  authorization_url = "https://accounts.google.com/o/oauth2/auth"
  client_id         = data.azurerm_key_vault_secret.one_identity_pagopa_client.value
  client_secret     = data.azurerm_key_vault_secret.one_identity_pagopa_client_secret.value
  token_url         = "https://oauth2.googleapis.com/token"
  trust_email = true
  default_scopes = "openid email profile"
  backchannel_supported = false
  gui_order = 0
  store_token = false
  sync_mode = "IMPORT"
  extra_config = {
    "clientAuthMethod" = "client_secret_basic"
  }
  first_broker_login_flow_alias="first broker login"
}
