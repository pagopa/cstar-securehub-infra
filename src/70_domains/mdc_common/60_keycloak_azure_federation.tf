# =============================================================================
# Federazione Azure Entra per il login degli utenti del portale interno mdc
# (realm mdc)
#
# Scenario:
# - Gli utenti aziendali accedono al portale interno mdc tramite Microsoft
#   Entra ID (federazione OIDC).
# - Ogni utente che accede tramite Entra riceve il ruolo base "operator-read",
#   anche se era gia' presente nel realm ed e' stato auto-linkato all'IdP.
# - I ruoli del portale sono cumulativi: operator-write/operator-admin possono
#   coesistere con operator-read.
# =============================================================================

# -----------------------------------------------------------------------------
# Identity Provider OIDC verso Microsoft Entra ID sul realm mdc.
# Usa direttamente client_id/secret dell'App Registration dedicata creata in
# 60_keycloak_mdc_portal_entra.tf (module.keycloak_mdc_portal_app), senza
# passare dalla Key Vault (stesso stack).
# -----------------------------------------------------------------------------

# First Broker Login dedicato a Entra:
# - se username/email non esistono, crea normalmente l'utente;
# - se esiste gia' un utente locale con la stessa username/email, lo collega
#   automaticamente all'identita' Entra senza creare un duplicato.
#
# L'auto-link e' limitato a questo IdP e presuppone che l'identita' Entra sia
# attendibile (tenant dedicato + trust_email = true).
resource "keycloak_authentication_flow" "azure_entra_first_broker_login" {
  realm_id    = local.keycloak_realm_id
  alias       = "azure-entra-first-broker-login"
  description = "Crea o collega automaticamente per email gli utenti Microsoft Entra ID"
  provider_id = "basic-flow"
}

resource "keycloak_authentication_execution" "azure_entra_create_user_if_unique" {
  realm_id          = local.keycloak_realm_id
  parent_flow_alias = keycloak_authentication_flow.azure_entra_first_broker_login.alias
  authenticator     = "idp-create-user-if-unique"
  requirement       = "ALTERNATIVE"
  priority          = 10
}

resource "keycloak_authentication_execution" "azure_entra_auto_link" {
  realm_id          = local.keycloak_realm_id
  parent_flow_alias = keycloak_authentication_flow.azure_entra_first_broker_login.alias
  authenticator     = "idp-auto-link"
  requirement       = "ALTERNATIVE"
  priority          = 20

  depends_on = [
    keycloak_authentication_execution.azure_entra_create_user_if_unique
  ]
}

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
  # Anche il mapper del ruolo base usa FORCE per coprire gli utenti auto-linkati.
  sync_mode   = "FORCE"
  trust_email = true

  first_broker_login_flow_alias = keycloak_authentication_flow.azure_entra_first_broker_login.alias

  depends_on = [
    keycloak_authentication_execution.azure_entra_auto_link
  ]
}

# -----------------------------------------------------------------------------
# Mapper di profilo: popolano username, nome, cognome ed email dai claim Entra
# -----------------------------------------------------------------------------
# username = preferred_username (UPN = email aziendale). E' la STESSA chiave di
# account linking usata dal mapper Selfcare (mapper-selfcare-username in
# 60_keycloak_ar_backoffice.tf): cosi' l'utente che accede da Entra e quello che
# accede da Selfcare convergono sullo stesso record Keycloak.
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
# Client roles del portale: sono isolati nel namespace del client e non possono
# essere confusi con i permessi di altre applicazioni nello stesso realm.
# I ruoli sono cumulativi: admin include write, che include read.
# -----------------------------------------------------------------------------
resource "keycloak_role" "portal_operator_read" {
  realm_id    = local.keycloak_realm_id
  client_id   = keycloak_openid_client.ar_backoffice_portal_client.id
  name        = "operator-read"
  description = "Operatore del portale in sola lettura"
}

resource "keycloak_role" "portal_operator_write" {
  realm_id    = local.keycloak_realm_id
  client_id   = keycloak_openid_client.ar_backoffice_portal_client.id
  name        = "operator-write"
  description = "Operatore del portale in scrittura"
  composite_roles = [
    keycloak_role.portal_operator_read.id
  ]
}

resource "keycloak_role" "portal_operator_admin" {
  realm_id    = local.keycloak_realm_id
  client_id   = keycloak_openid_client.ar_backoffice_portal_client.id
  name        = "operator-admin"
  description = "Amministratore del portale"
  composite_roles = [
    keycloak_role.portal_operator_write.id
  ]
}


# -----------------------------------------------------------------------------
# Client role BASE per ogni login via Azure: operator-read.
# syncMode = FORCE e' necessario anche per gli utenti preesistenti auto-linkati:
# IMPORT esegue l'assegnazione solo quando Keycloak crea un nuovo utente.
# L'operazione e' idempotente e non rimuove operator-write/operator-admin.
# -----------------------------------------------------------------------------
resource "keycloak_custom_identity_provider_mapper" "azure_default_operator_read" {
  realm                    = local.keycloak_realm_id
  name                     = "azure-default-operator-read"
  identity_provider_alias  = keycloak_oidc_identity_provider.azure_entra.alias
  identity_provider_mapper = "oidc-hardcoded-role-idp-mapper"

  extra_config = {
    syncMode = "FORCE"
    role     = "${keycloak_openid_client.ar_backoffice_portal_client.client_id}.${keycloak_role.portal_operator_read.name}"
  }
}
