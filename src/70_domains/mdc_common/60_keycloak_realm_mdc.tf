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

# create send client
resource "keycloak_openid_client" "emd_pagopa_mdc_send_client" {
  realm_id                  = keycloak_realm.mdc.id
  name                      = "send client"

  client_id                 = data.azurerm_key_vault_secret.send_client_id.value
  client_secret             = data.azurerm_key_vault_secret.send_client_secret.value

  enabled                   = true
  access_type               = "CONFIDENTIAL"
  service_accounts_enabled  = true

}

# create pagopa client
resource "keycloak_openid_client" "emd_pagopa_mdc_pagopa_client" {
  realm_id                  = keycloak_realm.mdc.id
  name                      = "pagopa client"

  client_id                 = data.azurerm_key_vault_secret.emd_pagopa_client_id.value
  client_secret             = data.azurerm_key_vault_secret.emd_pagopa_client_secret.value

  enabled                   = true
  access_type               = "CONFIDENTIAL"
  service_accounts_enabled  = true

}

# create emd-tpp-test client
resource "keycloak_openid_client" "emd_pagopa_mdc_emd_tpp_test_client" {
  realm_id                  = keycloak_realm.mdc.id
  name                      = "emd-tpp-test client"

  client_id                 = data.azurerm_key_vault_secret.emd_tpp_test_client_id.value
  client_secret             = data.azurerm_key_vault_secret.emd_tpp_test_client_secret.value

  enabled                   = true
  access_type               = "CONFIDENTIAL"
  service_accounts_enabled  = true

}

# Send group
resource "keycloak_group" "emd_pagopa_mdc_send_group" {
  realm_id = keycloak_realm.mdc.id
  name     = "send"
}

# Pagopa group
resource "keycloak_group" "emd_pagopa_mdc_pagopa_group" {
  realm_id = keycloak_realm.mdc.id
  name     = "emd-pagopa"
}

# Emd-tpp group
resource "keycloak_group" "emd_pagopa_mdc_emd_tpp_group" {
  realm_id = keycloak_realm.mdc.id
  name     = "emd-tpp"
}

# Assign send client to group
resource "keycloak_user_groups" "service_account_group_membership_send" {
  realm_id = keycloak_realm.mdc.id
  user_id  = keycloak_openid_client.emd_pagopa_mdc_send_client.service_account_user_id
  group_ids = [
    keycloak_group.emd_pagopa_mdc_send_group.id
  ]
}

# Assign pagopa client to group
resource "keycloak_user_groups" "service_account_group_membership_pagopa" {
  realm_id = keycloak_realm.mdc.id
  user_id  = keycloak_openid_client.emd_pagopa_mdc_pagopa_client.service_account_user_id
  group_ids = [
    keycloak_group.emd_pagopa_mdc_pagopa_group.id
  ]
}

# Assign emd-tpp-test client to group
resource "keycloak_user_groups" "service_account_group_membership_emd-tpp-test" {
  realm_id = keycloak_realm.mdc.id
  user_id  = keycloak_openid_client.emd_pagopa_mdc_emd_tpp_test_client.service_account_user_id
  group_ids = [
    keycloak_group.emd_pagopa_mdc_emd_tpp_group.id
  ]
}
