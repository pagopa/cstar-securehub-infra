
# See https://github.com/keycloak/terraform-provider-keycloak/blob/main/example/main.tf
resource "keycloak_realm" "merchant_operator" {
  realm        = "merchant-operator"
  enabled      = true
  display_name = "merchant-operator"

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

  web_origins = [
    local.keycloak_external_hostname,
    "http://localhost:5173",
  ]

  valid_redirect_uris = [
    "${local.keycloak_external_hostname}/*",
    "http://localhost:5173/*",
  ]

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
