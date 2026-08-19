# =============================================================================
# Federazione Azure Entra per il login degli utenti del portale interno mdc
# (realm mdc)
#
# Scenario:
# - Gli utenti aziendali accedono al portale interno mdc tramite Microsoft
#   Entra ID (federazione OIDC).
# - Al PRIMO login un utente riceve automaticamente il ruolo "operator-read"
#   (operatore in sola lettura). Nei login successivi il ruolo NON viene
#   sovrascritto (syncMode = IMPORT), così un amministratore puo' modificarlo
#   dal portale (via ar_backoffice_admin_client, che ha manage-users).
# =============================================================================

# -----------------------------------------------------------------------------
# Identity Provider OIDC verso Microsoft Entra ID sul realm mdc.
# Usa direttamente client_id/secret dell'App Registration dedicata creata in
# 60_keycloak_mdc_portal_entra.tf (module.keycloak_mdc_portal_app), senza
# passare dalla Key Vault (stesso stack).
# -----------------------------------------------------------------------------
resource "keycloak_oidc_identity_provider" "azure_entra" {
  realm        = local.keycloak_realm_id
  alias        = "azure-entra"
  display_name = "Microsoft Entra ID"
  enabled      = true

  authorization_url = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/oauth2/v2.0/authorize"
  token_url         = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/oauth2/v2.0/token"

  client_id     = module.keycloak_mdc_portal_app.azure_client_id
  client_secret = module.keycloak_mdc_portal_app.azure_client_secret

  default_scopes = "openid profile email"

  # FORCE = i mapper di profilo (nome/cognome/email) si aggiornano ad ogni login.
  # Il mapper del ruolo di default sovrascrive con syncMode = IMPORT (vedi sotto).
  sync_mode   = "FORCE"
  trust_email = true
}

# -----------------------------------------------------------------------------
# Mapper di profilo: popolano username, nome, cognome ed email dai claim Entra
# -----------------------------------------------------------------------------
resource "keycloak_custom_identity_provider_mapper" "azure_username" {
  realm                    = local.keycloak_realm_id
  name                     = "mapper-azure-username"
  identity_provider_alias  = keycloak_oidc_identity_provider.azure_entra.alias
  identity_provider_mapper = "oidc-username-idp-mapper"

  extra_config = {
    syncMode = "INHERIT"
    template = "$${CLAIM.preferred_username}"
  }
}

resource "keycloak_custom_identity_provider_mapper" "azure_first_name" {
  realm                    = local.keycloak_realm_id
  name                     = "mapper-azure-firstname"
  identity_provider_alias  = keycloak_oidc_identity_provider.azure_entra.alias
  identity_provider_mapper = "oidc-user-attribute-idp-mapper"

  extra_config = {
    syncMode         = "INHERIT"
    claim            = "given_name"
    "user.attribute" = "firstName"
  }
}

resource "keycloak_custom_identity_provider_mapper" "azure_last_name" {
  realm                    = local.keycloak_realm_id
  name                     = "mapper-azure-lastname"
  identity_provider_alias  = keycloak_oidc_identity_provider.azure_entra.alias
  identity_provider_mapper = "oidc-user-attribute-idp-mapper"

  extra_config = {
    syncMode         = "INHERIT"
    claim            = "family_name"
    "user.attribute" = "lastName"
  }
}

resource "keycloak_custom_identity_provider_mapper" "azure_email" {
  realm                    = local.keycloak_realm_id
  name                     = "mapper-azure-email"
  identity_provider_alias  = keycloak_oidc_identity_provider.azure_entra.alias
  identity_provider_mapper = "oidc-user-attribute-idp-mapper"

  extra_config = {
    syncMode = "INHERIT"
    # Entra non emette sempre il claim "email" (dipende dall'attributo mail in
    # directory). "preferred_username" contiene lo UPN (email aziendale) ed e'
    # sempre presente, quindi lo usiamo come sorgente dell'email.
    claim            = "preferred_username"
    "user.attribute" = "email"
  }
}

# Forza emailVerified = true. L'email e' popolata via mapper di attributo (non
# dal claim "email" nativo), quindi trust_email non basta a marcarla verificata:
# senza questo, Keycloak chiede la conferma dell'email. Gli utenti sono aziendali
# federati da Entra, quindi l'email e' considerata attendibile.
resource "keycloak_hardcoded_attribute_identity_provider_mapper" "azure_email_verified" {
  realm                   = local.keycloak_realm_id
  identity_provider_alias = keycloak_oidc_identity_provider.azure_entra.alias
  name                    = "email-verified"

  attribute_name  = "emailVerified"
  attribute_value = "true"
  user_session    = false

  extra_config = {
    syncMode = "INHERIT"
  }
}

# -----------------------------------------------------------------------------
# Ruoli di realm del portale (assegnabili a qualsiasi utente), naming uniforme:
# operator-read / operator-write / operator-admin.
# operator-admin era prima il ruolo "admin" (keycloak_role.realm_admin_role):
# rinominato tramite il moved block sotto, cosi' Keycloak NON lo ricrea.
# -----------------------------------------------------------------------------
resource "keycloak_role" "operator_read" {
  realm_id    = local.keycloak_realm_id
  name        = "operator-read"
  description = "Operatore in sola lettura (ruolo di default al primo login Azure)"
}

resource "keycloak_role" "operator_write" {
  realm_id    = local.keycloak_realm_id
  name        = "operator-write"
  description = "Operatore in scrittura"
}

resource "keycloak_role" "operator_admin" {
  realm_id    = local.keycloak_realm_id
  name        = "operator-admin"
  description = "Amministratore del portale"
}

# Rinomina il vecchio ruolo "admin" -> "operator-admin" senza ricrearlo.
moved {
  from = keycloak_role.realm_admin_role
  to   = keycloak_role.operator_admin
}

# -----------------------------------------------------------------------------
# Ruolo di DEFAULT al primo login via Azure: operator-read
# syncMode = IMPORT -> assegnato solo al primo login; i login successivi non
# sovrascrivono i ruoli, cosi' l'amministratore puo' modificarli dal portale.
# -----------------------------------------------------------------------------
resource "keycloak_custom_identity_provider_mapper" "azure_default_operator_read" {
  realm                    = local.keycloak_realm_id
  name                     = "azure-default-operator-read"
  identity_provider_alias  = keycloak_oidc_identity_provider.azure_entra.alias
  identity_provider_mapper = "oidc-hardcoded-role-idp-mapper"

  extra_config = {
    syncMode = "IMPORT"
    role     = keycloak_role.operator_read.name
  }
}
