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

######################
# REALM ROLES
######################

resource "keycloak_role" "write_rtp_activations" {
  realm_id    = keycloak_realm.srtp.id
  name        = "write_rtp_activations"
  description = "Role to write RTP activations"
}

resource "keycloak_role" "read_rtp_activations" {
  realm_id    = keycloak_realm.srtp.id
  name        = "read_rtp_activations"
  description = "Role to read RTP activations"
}

resource "keycloak_role" "read_rtp_payees" {
  realm_id    = keycloak_realm.srtp.id
  name        = "read_rtp_payees"
  description = "Role to read RTP payees"
}

resource "keycloak_role" "process_rtp_send" {
  realm_id    = keycloak_realm.srtp.id
  name        = "process_rtp_send"
  description = "Role to process RTP send"
}

resource "keycloak_role" "read_rtp_send" {
  realm_id    = keycloak_realm.srtp.id
  name        = "read_rtp_send"
  description = "Role to read RTPs"
}

resource "keycloak_role" "read_rtp_all" {
  realm_id    = keycloak_realm.srtp.id
  name        = "read_rtp_all"
  description = "Role to read all RTPs"
}

resource "keycloak_role" "write_rtp_send" {
  realm_id    = keycloak_realm.srtp.id
  name        = "write_rtp_send"
  description = "Role to write RTPs"
}

resource "keycloak_role" "payee_read_rtp" {
  realm_id    = keycloak_realm.srtp.id
  name        = "payee_read_rtp"
  description = "Role for payee to read RTP"
}

resource "keycloak_role" "read_service_registry" {
  realm_id    = keycloak_realm.srtp.id
  name        = "read_service_registry"
  description = "Role to read service registry"
}


######################
# READ_RTP_ACTIVATIONS Client (CONFIDENTIAL)
######################

resource "keycloak_openid_client" "read_rtp_activations" {
  realm_id = keycloak_realm.srtp.id
  name     = "15376371009"
  enabled  = true

  client_id                = data.azurerm_key_vault_secret.read_rtp_activations_client_id.value
  client_secret_wo         = data.azurerm_key_vault_secret.read_rtp_activations_client_secret.value
  client_secret_wo_version = 3

  access_type                  = "CONFIDENTIAL"
  service_accounts_enabled     = true
  standard_flow_enabled        = false
  direct_access_grants_enabled = false

  depends_on = [
    keycloak_realm.srtp,
  ]
}

resource "keycloak_openid_client_service_account_realm_role" "read_rtp_activations_write_rtp_activations_role" {
  realm_id                = keycloak_realm.srtp.id
  service_account_user_id = keycloak_openid_client.read_rtp_activations.service_account_user_id
  role                    = keycloak_role.write_rtp_activations.name
}

resource "keycloak_openid_client_service_account_realm_role" "read_rtp_activations_read_rtp_activations_role" {
  realm_id                = keycloak_realm.srtp.id
  service_account_user_id = keycloak_openid_client.read_rtp_activations.service_account_user_id
  role                    = keycloak_role.read_rtp_activations.name
}

resource "keycloak_openid_hardcoded_claim_protocol_mapper" "read_rtp_activations_sub_mapper" {
  realm_id  = keycloak_realm.srtp.id
  client_id = keycloak_openid_client.read_rtp_activations.id
  name      = "sub-mapper"

  claim_name       = "sub"
  claim_value      = keycloak_openid_client.read_rtp_activations.name
  claim_value_type = "String"
}

resource "keycloak_openid_hardcoded_claim_protocol_mapper" "read_rtp_activations_subject_mapper" {
  realm_id  = keycloak_realm.srtp.id
  client_id = keycloak_openid_client.read_rtp_activations.id
  name      = "subject-mapper"

  claim_name       = "subject"
  claim_value      = keycloak_openid_client.read_rtp_activations.name
  claim_value_type = "String"
}


######################
# READ_RTP_PAYEES Client (CONFIDENTIAL)
######################

resource "keycloak_openid_client" "read_rtp_payees" {
  realm_id = keycloak_realm.srtp.id
  name     = "pagoPA"
  enabled  = true

  client_id                = data.azurerm_key_vault_secret.read_rtp_payees_client_id.value
  client_secret_wo         = data.azurerm_key_vault_secret.read_rtp_payees_client_secret.value
  client_secret_wo_version = 3

  access_type                  = "CONFIDENTIAL"
  service_accounts_enabled     = true
  standard_flow_enabled        = false
  direct_access_grants_enabled = false

  depends_on = [
    keycloak_realm.srtp,
  ]
}

resource "keycloak_openid_client_service_account_realm_role" "read_rtp_payees_read_rtp_payees_role" {
  realm_id                = keycloak_realm.srtp.id
  service_account_user_id = keycloak_openid_client.read_rtp_payees.service_account_user_id
  role                    = keycloak_role.read_rtp_payees.name
}

resource "keycloak_openid_hardcoded_claim_protocol_mapper" "read_rtp_payees_sub_mapper" {
  realm_id  = keycloak_realm.srtp.id
  client_id = keycloak_openid_client.read_rtp_payees.id
  name      = "sub-mapper"

  claim_name       = "sub"
  claim_value      = keycloak_openid_client.read_rtp_payees.name
  claim_value_type = "String"
}

resource "keycloak_openid_hardcoded_claim_protocol_mapper" "read_rtp_payees_subject_mapper" {
  realm_id  = keycloak_realm.srtp.id
  client_id = keycloak_openid_client.read_rtp_payees.id
  name      = "subject-mapper"

  claim_name       = "subject"
  claim_value      = keycloak_openid_client.read_rtp_payees.name
  claim_value_type = "String"
}


######################
# PROCESS_MESSAGE Client (CONFIDENTIAL)
######################

resource "keycloak_openid_client" "process_message" {
  realm_id = keycloak_realm.srtp.id
  name     = "RTP-CONSUMER_CLIENT"
  enabled  = true

  client_id                = data.azurerm_key_vault_secret.mil_auth_client_id_consumer.value
  client_secret_wo         = data.azurerm_key_vault_secret.mil_auth_client_secret_consumer.value
  client_secret_wo_version = 3

  access_type                  = "CONFIDENTIAL"
  service_accounts_enabled     = true
  standard_flow_enabled        = false
  direct_access_grants_enabled = false

  depends_on = [
    keycloak_realm.srtp,
  ]
}

resource "keycloak_openid_client_service_account_realm_role" "process_message_process_rtp_send_role" {
  realm_id                = keycloak_realm.srtp.id
  service_account_user_id = keycloak_openid_client.process_message.service_account_user_id
  role                    = keycloak_role.process_rtp_send.name
}

resource "keycloak_openid_hardcoded_claim_protocol_mapper" "process_message_sub_mapper" {
  realm_id  = keycloak_realm.srtp.id
  client_id = keycloak_openid_client.process_message.id
  name      = "sub-mapper"

  claim_name       = "sub"
  claim_value      = keycloak_openid_client.process_message.name
  claim_value_type = "String"
}

resource "keycloak_openid_hardcoded_claim_protocol_mapper" "process_message_subject_mapper" {
  realm_id  = keycloak_realm.srtp.id
  client_id = keycloak_openid_client.process_message.id
  name      = "subject-mapper"

  claim_name       = "subject"
  claim_value      = keycloak_openid_client.process_message.name
  claim_value_type = "String"
}


######################
# Internal Test Webform (PUBLIC)
######################

resource "keycloak_openid_client" "internal_test_webform" {
  realm_id  = keycloak_realm.srtp.id
  client_id = "internal-test-webform"
  name      = "Internal Test Webform"
  enabled   = true

  access_type = "PUBLIC"

  standard_flow_enabled        = false
  direct_access_grants_enabled = true

  depends_on = [keycloak_realm.srtp]
}

resource "keycloak_openid_hardcoded_claim_protocol_mapper" "internal_test_webform_sub_mapper" {
  realm_id  = keycloak_realm.srtp.id
  client_id = keycloak_openid_client.internal_test_webform.id
  name      = "sub-mapper"

  claim_name       = "sub"
  claim_value      = keycloak_openid_client.internal_test_webform.name
  claim_value_type = "String"
}

resource "keycloak_openid_hardcoded_claim_protocol_mapper" "internal_test_webform_subject_mapper" {
  realm_id  = keycloak_realm.srtp.id
  client_id = keycloak_openid_client.internal_test_webform.id
  name      = "subject-mapper"

  claim_name       = "subject"
  claim_value      = keycloak_openid_client.internal_test_webform.name
  claim_value_type = "String"
}
