# Realm configuration for Keycloak
resource "keycloak_realm" "mdc" {
  realm        = "mdc"
  enabled      = true
  display_name = "Messaggi di cortesia"

  # Durata dei token (opzionale)
  access_token_lifespan = "30m"

  # Algoritmo di firma predefinito
  default_signature_algorithm = "RS256"

}

# Generazione Password Casuale per il Client Secret
resource "random_password" "keycloak_client_secret" {
  length  = 32
  special = false
}

# create a client 
resource "keycloak_openid_client" "emd-pagopa-mdc-client" {
  realm_id                  = keycloak_realm.mdc.id
  name                      = "emd-tpp-test client"

  client_id                 = "emd-tpp-test"
  client_secret             = random_password.keycloak_client_secret.result

  enabled                   = true
  access_type               = "CONFIDENTIAL"
  service_accounts_enabled  = true

}

# Client group
resource "keycloak_group" "mdc_service_group" {
  realm_id = keycloak_realm.mdc.id
  name     = "MDC-Group"
}

# Assign client to group
resource "keycloak_user_groups" "service_account_group_membership" {
  realm_id = keycloak_realm.mdc.id
  user_id  = keycloak_openid_client.emd-pagopa-mdc-client.service_account_user_id
  group_ids = [
    keycloak_group.mdc_service_group.id
  ]
}