
# See https://github.com/keycloak/terraform-provider-keycloak/blob/main/example/main.tf
resource "keycloak_realm" "merchant-operator" {
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
