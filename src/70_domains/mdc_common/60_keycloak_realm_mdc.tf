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

### Client settings ###

# Create the scope for groups
resource "keycloak_openid_client_scope" "mdc_base_claims" {
  realm_id = keycloak_realm.mdc.id
  name     = "mdc-claims"
}

# Add the mapper to the scope to include group information in the token
resource "keycloak_openid_group_membership_protocol_mapper" "groups_mapper" {
  realm_id            = keycloak_realm.mdc.id
  client_scope_id     = keycloak_openid_client_scope.mdc_base_claims.id
  name                = "groups-mapper"
  claim_name          = "groups"
  full_path           = false
  add_to_access_token = true
  add_to_id_token     = true
}

# Add audience to the token
resource "keycloak_openid_audience_protocol_mapper" "aud_mapper" {
  realm_id        = keycloak_realm.mdc.id
  client_scope_id = keycloak_openid_client_scope.mdc_base_claims.id
  name            = "audience-mapper"
  included_custom_audience = "keycloak.pagopa.it" # Valore dell'audience per tutti
  add_to_access_token      = true
}

# Mapper for clientId - The User Session Note Mapper extract the current client_id
resource "keycloak_openid_user_session_note_protocol_mapper" "client_id_mapper" {
  realm_id        = keycloak_realm.mdc.id
  client_scope_id = keycloak_openid_client_scope.mdc_base_claims.id
  name            = "client-id-mapper"
  claim_name      = "clientId"
  session_note    = "client_id"
  add_to_access_token = true
}

# Create send client
resource "keycloak_openid_client" "emd_pagopa_mdc_send_client" {
  realm_id = keycloak_realm.mdc.id
  name     = "send client"

  client_id     = data.azurerm_key_vault_secret.send_client_id.value
  client_secret = data.azurerm_key_vault_secret.send_client_secret.value

  enabled                  = true
  access_type              = "CONFIDENTIAL"
  service_accounts_enabled = true

}

# Send client default scopes
resource "keycloak_openid_client_default_scopes" "emd_pagopa_mdc_send_client_default_scopes" {
  realm_id  = keycloak_realm.mdc.id
  client_id = keycloak_openid_client.emd_pagopa_mdc_send_client.id

  default_scopes = [
    "openid",
    "profile",
    keycloak_openid_client_scope.mdc_base_claims.name,
  ]
}

# create pagopa client
resource "keycloak_openid_client" "emd_pagopa_mdc_pagopa_client" {
  realm_id = keycloak_realm.mdc.id
  name     = "pagopa client"

  client_id     = data.azurerm_key_vault_secret.emd_pagopa_client_id.value
  client_secret = data.azurerm_key_vault_secret.emd_pagopa_client_secret.value

  enabled                  = true
  access_type              = "CONFIDENTIAL"
  service_accounts_enabled = true

}

# Pagopa client default scopes
resource "keycloak_openid_client_default_scopes" "emd_pagopa_mdc_pagopa_client_default_scopes" {
  realm_id  = keycloak_realm.mdc.id
  client_id = keycloak_openid_client.emd_pagopa_mdc_pagopa_client.id

  default_scopes = [
    "openid",
    "profile",
    keycloak_openid_client_scope.mdc_base_claims.name,
  ]
}

# create emd-tpp-test client
resource "keycloak_openid_client" "emd_pagopa_mdc_emd_tpp_test_client" {
  realm_id = keycloak_realm.mdc.id
  name     = "emd-tpp-test client"

  client_id     = data.azurerm_key_vault_secret.emd_tpp_test_client_id.value
  client_secret = data.azurerm_key_vault_secret.emd_tpp_test_client_secret.value

  enabled                  = true
  access_type              = "CONFIDENTIAL"
  service_accounts_enabled = true

}

# Emd-tpp-test client default scopes
resource "keycloak_openid_client_default_scopes" "emd_pagopa_mdc_emd_tpp_test_client_default_scopes" {
  realm_id  = keycloak_realm.mdc.id
  client_id = keycloak_openid_client.emd_pagopa_mdc_emd_tpp_test_client.id

  default_scopes = [
    "openid",
    "profile",
    keycloak_openid_client_scope.mdc_base_claims.name,
  ]
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
