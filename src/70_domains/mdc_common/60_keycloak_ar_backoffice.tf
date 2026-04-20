# Apply online with the terraform user that has admin access to keycloak
# resource "keycloak_oidc_identity_provider" "selfcare_te_oidc" {
#   realm             = local.keycloak_realm_id
#   alias             = local.keycloak_selfcare_idp_te_alias
#   enabled           = true
#
#   authorization_url = "https://dummy.com/auth"
#   token_url         = "https://dummy.com/token"
#   client_id         = "dummy"
#   client_secret     = "dummy" # In TF è obbligatorio se si usa auth method client_secret_post
#
#   issuer             = local.selfcare_issuer
#   jwks_url           = "${local.selfcare_issuer}/.well-known/jwks.json"
#   validate_signature = true
#   sync_mode          = "IMPORT"
#
#   extra_config = {
#     "jwtAuthorizationGrantEnabled"                       = "true"
#     "jwtAuthorizationGrantMaxAllowedAssertionExpiration" = "300"
#     "jwtAuthorizationGrantAssertionReuseAllowed"         = "false"
#     "jwtAuthorizationGrantLimitAccessTokenExp"           = "false"
#     "jwtAuthorizationGrantAssertionSignatureAlg"         = ""
#     "allowClientIdAsAudience"                            = "false"
#     "clientAuthMethod"                                   = "client_secret_post"
#   }
# }

resource "keycloak_openid_client" "admin_client" {
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

data "keycloak_openid_client" "realm_management" {
  realm_id  = local.keycloak_realm_id
  client_id = "realm-management"
}
data "keycloak_role" "manage_users" {
  realm_id  = local.keycloak_realm_id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "manage-users"
}

resource "keycloak_openid_client_service_account_role" "admin_client_manage_users" {
  realm_id                = local.keycloak_realm_id
  service_account_user_id = keycloak_openid_client.admin_client.service_account_user_id
  client_id               = data.keycloak_openid_client.realm_management.id
  role                    = data.keycloak_role.manage_users.name
}

resource "keycloak_openid_client" "backoffice_client" {
  realm_id      = local.keycloak_realm_id
  client_id     = module.secrets.values["ar-backoffice-client-id"].value
  client_secret = module.secrets.values["ar-backoffice-client-secret"].value

  name        = "AR Backoffice"
  enabled     = true
  access_type = "CONFIDENTIAL"

  standard_flow_enabled        = false
  direct_access_grants_enabled = false

  extra_config = {
    "oauth2.jwt.authorization.grant.enabled" = "true"
    "oauth2.jwt.authorization.grant.idp"     = local.keycloak_selfcare_idp_te_alias
  }
}
