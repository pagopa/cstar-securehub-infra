# Apply online with the terraform user that has admin access to keycloak
resource "keycloak_oidc_identity_provider" "selfcare_te_oidc" {
  realm   = local.keycloak_realm_id
  alias   = local.keycloak_selfcare_idp_te_alias
  enabled = true

  authorization_url = "https://dummy.com/auth"
  token_url         = "https://dummy.com/token"
  client_id         = "dummy"
  client_secret     = "dummy" # In TF è obbligatorio se si usa auth method client_secret_post

  issuer             = local.selfcare_issuer
  jwks_url           = "${local.selfcare_issuer}/.well-known/jwks.json"
  validate_signature = true
  sync_mode          = "IMPORT"

  extra_config = {
    "jwtAuthorizationGrantEnabled"                       = "true"
    "jwtAuthorizationGrantMaxAllowedAssertionExpiration" = "300"
    "jwtAuthorizationGrantAssertionReuseAllowed"         = "false"
    "jwtAuthorizationGrantLimitAccessTokenExp"           = "false"
    "jwtAuthorizationGrantAssertionSignatureAlg"         = ""
    "allowClientIdAsAudience"                            = "false"
    "clientAuthMethod"                                   = "client_secret_post"
  }
}

resource "keycloak_openid_client" "ar_backoffice_admin_client" {
  realm_id      = local.keycloak_realm_id
  client_id     = module.secrets.values["ar-backoffice-admin-client-id"].value
  client_secret = module.secrets.values["ar-backoffice-admin-client-secret"].value

  name        = "AR Backoffice Admin"
  enabled     = true
  access_type = "CONFIDENTIAL"

  service_accounts_enabled     = true
  standard_flow_enabled        = false
  direct_access_grants_enabled = false
}

resource "keycloak_openid_client_default_scopes" "ar_backoffice_admin_client_default_scopes" {
  realm_id  = local.keycloak_realm_id
  client_id = keycloak_openid_client.ar_backoffice_admin_client.id

  default_scopes = [
    keycloak_openid_client_scope.mdc_base_claims.name,
  ]
}

data "keycloak_openid_client" "realm_management" {
  realm_id  = local.keycloak_realm_id
  client_id = "realm-management"
}
data "keycloak_role" "manage_users" {
  realm_id  = local.keycloak_realm_id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "manage-users"
}
data "keycloak_role" "manage_clients" {
  realm_id  = local.keycloak_realm_id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "manage-clients"
}

resource "keycloak_openid_client_service_account_role" "ar_backoffice_admin_client_manage_users" {
  realm_id                = local.keycloak_realm_id
  service_account_user_id = keycloak_openid_client.ar_backoffice_admin_client.service_account_user_id
  client_id               = data.keycloak_openid_client.realm_management.id
  role                    = data.keycloak_role.manage_users.name
}

resource "keycloak_openid_client_service_account_role" "ar_backoffice_admin_client_manage_clients" {
  realm_id                = local.keycloak_realm_id
  service_account_user_id = keycloak_openid_client.ar_backoffice_admin_client.service_account_user_id
  client_id               = data.keycloak_openid_client.realm_management.id
  role                    = data.keycloak_role.manage_clients.name
}

resource "keycloak_openid_client" "ar_backoffice_client" {
  realm_id      = local.keycloak_realm_id
  client_id     = module.secrets.values["ar-backoffice-client-id"].value
  client_secret = module.secrets.values["ar-backoffice-client-secret"].value

  name        = "AR Backoffice"
  enabled     = true
  access_type = "CONFIDENTIAL"

  standard_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled = true

  use_refresh_tokens = true

  extra_config = {
    "oauth2.jwt.authorization.grant.enabled" = "true"
    "oauth2.jwt.authorization.grant.idp"     = local.keycloak_selfcare_idp_te_alias
  }
}

resource "keycloak_openid_user_attribute_protocol_mapper" "ar_backoffice_client_username_mapper" {
  realm_id  = local.keycloak_realm_id
  client_id = keycloak_openid_client.ar_backoffice_client.id

  name             = "username-mapper"
  user_attribute   = "username"
  claim_name       = "username"
  claim_value_type = "String"

  add_to_access_token = true
  add_to_id_token     = true
  add_to_userinfo     = true
}

resource "keycloak_openid_user_attribute_protocol_mapper" "ar_backoffice_client_org_id_mapper" {
  realm_id  = local.keycloak_realm_id
  client_id = keycloak_openid_client.ar_backoffice_client.id

  name             = "org-id-mapper"
  user_attribute   = "orgId"
  claim_name       = "orgId"
  claim_value_type = "String"

  add_to_access_token = true
  add_to_id_token     = true
  add_to_userinfo     = true
}

resource "keycloak_openid_user_attribute_protocol_mapper" "ar_backoffice_client_org_roles_mapper" {
  realm_id  = local.keycloak_realm_id
  client_id = keycloak_openid_client.ar_backoffice_client.id

  name             = "org-roles-mapper"
  user_attribute   = "orgRoles"
  claim_name       = "orgRoles"
  claim_value_type = "String"
  multivalued      = true

  add_to_access_token = true
  add_to_id_token     = true
  add_to_userinfo     = true
}

resource "keycloak_openid_user_attribute_protocol_mapper" "ar_backoffice_client_org_fiscal_code_mapper" {
  realm_id  = local.keycloak_realm_id
  client_id = keycloak_openid_client.ar_backoffice_client.id

  name             = "org-fiscal-code-mapper"
  user_attribute   = "orgFiscalCode"
  claim_name       = "orgFiscalCode"
  claim_value_type = "String"

  add_to_access_token = true
  add_to_id_token     = true
  add_to_userinfo     = true
}

resource "keycloak_openid_client_optional_scopes" "ar_backoffice_client_optional_scopes" {
  realm_id  = local.keycloak_realm_id
  client_id = keycloak_openid_client.ar_backoffice_client.id

  optional_scopes = []
}

resource "keycloak_openid_client_default_scopes" "ar_backoffice_client_default_scopes" {
  realm_id  = local.keycloak_realm_id
  client_id = keycloak_openid_client.ar_backoffice_client.id

  default_scopes = [
    "offline_access",
    keycloak_openid_client_scope.mdc_base_claims.name
  ]

  depends_on = [keycloak_openid_client_optional_scopes.ar_backoffice_client_optional_scopes]
}
