# ----------------------------------------------------------------------------
# HUB-SPOKE REALM: CENTRAL AUTHENTICATION GATEWAY
#
# This realm acts as the primary Identity Hub for all applications.
# It serves as a bridge between Microsoft Entra ID (the source of truth)
# and downstream project-specific realms (the Spokes).
# ----------------------------------------------------------------------------

resource "keycloak_realm" "hub_spoke" {
  realm        = "hub-spoke"
  enabled      = true
  display_name = "Authentication Hub"

  sso_session_idle_timeout = "6h"
  sso_session_max_lifespan = "12h"

  browser_flow = "browser-azure-only" # Use the string alias directly to avoid circular dependency
}

resource "keycloak_oidc_identity_provider" "hub_spoke_oidc" {
  realm             = keycloak_realm.hub_spoke.realm
  alias             = "azure-entra"
  display_name      = "Microsoft Entra ID (Hub)"
  enabled           = true
  authorization_url = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/oauth2/v2.0/authorize"
  token_url         = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/oauth2/v2.0/token"

  client_id      = data.azuread_application.keycloak.client_id
  client_secret  = module.core_secrets.values["keycloak-azure-app-secret-value"].value
  default_scopes = "openid profile email"

  sync_mode   = "FORCE"
  trust_email = true

  backchannel_supported = false
}

resource "keycloak_custom_identity_provider_mapper" "azure_admin_mapper" {
  realm                    = keycloak_realm.hub_spoke.realm
  name                     = "azure-group-to-admin"
  identity_provider_alias  = keycloak_oidc_identity_provider.hub_spoke_oidc.alias
  identity_provider_mapper = "oidc-role-idp-mapper"

  extra_config = {
    syncMode      = "FORCE"
    claim         = "groups"
    "claim.value" = data.azuread_group.adgroup_admin.object_id
    role          = "realm-management.realm-admin"
  }
}

# ----------------------------------------------------------------------------
# AUTHENTICATION FLOW: ZERO-CLICK REDIRECT
# Bypasses local login forms to force immediate Azure AD federation.
# ----------------------------------------------------------------------------
resource "keycloak_authentication_flow" "azure_only_flow" {
  realm_id    = keycloak_realm.hub_spoke.id
  alias       = "browser-azure-only"
  description = "Redirects directly to Azure AD, bypassing local login"
}

# Required execution for the Zero-Click redirect
resource "keycloak_authentication_execution" "idp_redirector" {
  realm_id          = keycloak_realm.hub_spoke.id
  parent_flow_alias = keycloak_authentication_flow.azure_only_flow.alias
  authenticator     = "identity-provider-redirector"
  requirement       = "REQUIRED"
}

# Redirector configuration pointing to the Azure alias
resource "keycloak_authentication_execution_config" "idp_redirector_config" {
  realm_id     = keycloak_realm.hub_spoke.id
  execution_id = keycloak_authentication_execution.idp_redirector.id
  alias        = "azure-redirect-config"

  config = {
    defaultProvider = keycloak_oidc_identity_provider.hub_spoke_oidc.alias
  }
}

resource "keycloak_openid_client" "spoke_connector" {
  realm_id  = keycloak_realm.hub_spoke.id
  client_id = "spoke-realm-client"
  name      = "Global Connector for Spoke Realms"
  enabled   = true

  access_type           = "CONFIDENTIAL"
  standard_flow_enabled = true

  valid_redirect_uris = [
    "https://${local.keycloak_ingress_hostname}/realms/*/broker/spoke/endpoint"
  ]
}

# ----------------------------------------------------------------------------
# Propagate azure groups to spokes
# ----------------------------------------------------------------------------
resource "keycloak_openid_group_membership_protocol_mapper" "hub_to_spokes_groups" {
  realm_id   = keycloak_realm.hub_spoke.id
  client_id  = keycloak_openid_client.spoke_connector.id
  name       = "azure-groups-mapper"
  claim_name = "groups"
  full_path  = false
}
