# transpose core-kv to domain-kv url secret to let AKS pods access it
resource "azurerm_key_vault_secret" "keycloak_url_srtp" {
  name         = data.azurerm_key_vault_secret.keycloak_url.name
  value        = "https://${data.azurerm_key_vault_secret.keycloak_url.value}"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

######################
# SRTP REALM
######################
resource "keycloak_realm" "srtp" {
  realm        = "srtp"
  enabled      = true
  display_name = "SRTP"

  internationalization {
    supported_locales = [
      "it"
    ]
    default_locale = "it"
  }
}


resource "random_password" "keycloak_sender_random_password" {
  length  = 30
  special = false
}

resource "random_password" "keycloak_consumer_random_password" {
  length  = 30
  special = false
}

resource "azurerm_key_vault_secret" "keycloak_rtp_sender_app_client_secret" {
  name         = "keycloak-sender-client-secret"
  value        = random_password.keycloak_sender_random_password.result
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  depends_on = [random_password.keycloak_sender_random_password]
}

resource "azurerm_key_vault_secret" "keycloak_rtp_consumer_app_client_secret" {
  name         = "keycloak-consumer-client-secret"
  value        = random_password.keycloak_consumer_random_password.result
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  depends_on = [random_password.keycloak_consumer_random_password]
}

resource "keycloak_openid_client" "sender_app_client" {
  realm_id = keycloak_realm.srtp.id
  name     = "RTP Sender App Client"
  enabled  = true

  client_id                = "rtp-sender-app-client"
  client_secret_wo         = random_password.keycloak_sender_random_password.result
  client_secret_wo_version = 3

  access_type              = "CONFIDENTIAL"
  service_accounts_enabled = true

  depends_on = [random_password.keycloak_sender_random_password]
}

resource "keycloak_openid_client" "consumer_app_client" {
  realm_id = keycloak_realm.srtp.id
  name     = "RTP Consumer App Client"
  enabled  = true

  client_id                = "rtp-consumer-app-client"
  client_secret_wo         = random_password.keycloak_consumer_random_password.result
  client_secret_wo_version = 3

  access_type              = "CONFIDENTIAL"
  service_accounts_enabled = true

  depends_on = [random_password.keycloak_consumer_random_password]
}


resource "keycloak_realm_user_profile" "srtp_user_profile" {
  realm_id = keycloak_realm.srtp.id

  unmanaged_attribute_policy = "ENABLED"

  attribute {
    name         = "username"
    display_name = "BIC"

    multi_valued = false

    permissions {
      view = ["admin", "user"]
      edit = ["admin"]
    }
  }
}
