# traspose core-kv to domain-kv url secret to let AKS pods access it
resource "azurerm_key_vault_secret" "keycloak_url_idpay" {
  name         = data.azurerm_key_vault_secret.keycloak_url.name
  value        = "https://${data.azurerm_key_vault_secret.keycloak_url.value}"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

######################
# MERCHANT OPERATOR REALM
######################
resource "keycloak_realm" "merchant_operator" {
  realm        = "merchant-operator"
  enabled      = true
  display_name = "merchant-operator"

  login_theme = "pagopa"

  smtp_server {
    host = data.azurerm_key_vault_secret.ses_smtp_host.value
    port = local.ses_smtp_port
    from = data.azurerm_key_vault_secret.ses_from_address.value
    ssl  = true

    auth {
      username = data.azurerm_key_vault_secret.ses_smtp_username.value
      password = data.azurerm_key_vault_secret.ses_smtp_password.value
    }
  }
}

resource "keycloak_openid_client" "merchant_operator_frontend" {
  realm_id  = keycloak_realm.merchant_operator.id
  client_id = "frontend"
  name      = "Merchant Operator Frontend"
  enabled   = true

  access_type = "PUBLIC"

  standard_flow_enabled = true

  web_origins = flatten([
    [
      local.keycloak_external_hostname,
      "http://localhost:5173",
  ], formatlist("https://%s", local.public_dns_zone_bonus_elettrodomestici.zones)])

  valid_redirect_uris = flatten([
    [
      "${local.keycloak_external_hostname}/*",
      "http://localhost:5173/*",
  ], formatlist("https://%s/*", local.public_dns_zone_bonus_elettrodomestici.zones)])

  depends_on = [
    keycloak_realm.merchant_operator,
  ]
}

resource "random_password" "keycloak_merchant_operator_app_client" {
  length  = 30
  special = false
}

resource "azurerm_key_vault_secret" "keycloak_merchant_operator_app_client_secret" {
  name         = "keycloak-merchant-op-client-secret"
  value        = random_password.keycloak_merchant_operator_app_client.result
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  depends_on = [random_password.keycloak_merchant_operator_app_client]
}

# create a client for the sdk to access the merchant operator realm
resource "keycloak_openid_client" "merchant_operator_app_client" {
  realm_id = keycloak_realm.merchant_operator.id
  name     = "Merchant Op App Client"
  enabled  = true

  client_id                = "merchant-operator-app-client"
  client_secret_wo         = random_password.keycloak_merchant_operator_app_client.result
  client_secret_wo_version = 3

  access_type              = "CONFIDENTIAL"
  service_accounts_enabled = true

  depends_on = [random_password.keycloak_merchant_operator_app_client]
}


data "keycloak_openid_client" "realm_mgmt" {
  realm_id  = keycloak_realm.merchant_operator.id
  client_id = "realm-management"
}

data "keycloak_role" "manage_users" {
  realm_id   = keycloak_realm.merchant_operator.id
  client_id  = data.keycloak_openid_client.realm_mgmt.id
  name       = "manage-users"
  depends_on = [data.keycloak_openid_client.realm_mgmt]
}

data "keycloak_role" "query_users" {
  realm_id  = keycloak_realm.merchant_operator.id
  client_id = data.keycloak_openid_client.realm_mgmt.id
  name      = "query-users"

  depends_on = [data.keycloak_openid_client.realm_mgmt]
}

data "keycloak_role" "view_users" {
  realm_id  = keycloak_realm.merchant_operator.id
  client_id = data.keycloak_openid_client.realm_mgmt.id
  name      = "view-users"

  depends_on = [data.keycloak_openid_client.realm_mgmt]
}

resource "keycloak_openid_client_service_account_role" "app_client_service_account_role_manage_users" {
  realm_id                = keycloak_realm.merchant_operator.id
  service_account_user_id = keycloak_openid_client.merchant_operator_app_client.service_account_user_id
  client_id               = data.keycloak_openid_client.realm_mgmt.id
  role                    = data.keycloak_role.manage_users.name
}

resource "keycloak_openid_client_service_account_role" "app_client_service_account_role_view_users" {
  realm_id                = keycloak_realm.merchant_operator.id
  service_account_user_id = keycloak_openid_client.merchant_operator_app_client.service_account_user_id
  client_id               = data.keycloak_openid_client.realm_mgmt.id
  role                    = data.keycloak_role.manage_users.name
}

resource "keycloak_openid_client_service_account_role" "app_client_service_account_role_query_users" {
  realm_id                = keycloak_realm.merchant_operator.id
  service_account_user_id = keycloak_openid_client.merchant_operator_app_client.service_account_user_id
  client_id               = data.keycloak_openid_client.realm_mgmt.id
  role                    = data.keycloak_role.manage_users.name
}

##################
# USER REALM
##################
resource "keycloak_realm" "user" {
  realm        = "user"
  enabled      = true
  display_name = "user"
}

resource "keycloak_openid_client" "user_frontend" {
  realm_id  = keycloak_realm.user.id
  client_id = "frontend"
  name      = "Portal User Frontend"
  enabled   = true

  access_type = "PUBLIC"

  standard_flow_enabled = true

  web_origins = flatten([
    [
      local.keycloak_external_hostname,
      "http://localhost:5173",
  ], formatlist("https://%s", local.public_dns_zone_bonus_elettrodomestici.zones)])

  valid_redirect_uris = flatten([
    [
      "${local.keycloak_external_hostname}/*",
      "http://localhost:5173/*",
  ], formatlist("https://%s/*", local.public_dns_zone_bonus_elettrodomestici.zones)])

  depends_on = [
    keycloak_realm.user,
  ]
}

resource "keycloak_oidc_identity_provider" "one_identity_provider" {
  realm                 = keycloak_realm.user.id
  alias                 = "oneid-keycloak"
  display_name          = "OneIdentity"
  authorization_url     = "${var.oneidentity_base_url}/login"
  token_url             = "${var.oneidentity_base_url}/oidc/token"
  client_id             = data.azurerm_key_vault_secret.oneidentity-client-id.value
  client_secret         = data.azurerm_key_vault_secret.oneidentity-client-secret.value
  issuer                = var.oneidentity_base_url
  trust_email           = true
  store_token           = true
  sync_mode             = "LEGACY"
  validate_signature    = false
  backchannel_supported = false

  extra_config = {
    "clientAuthMethod" = "client_secret_basic"
    "pkceEnabled"      = true
    "pkceMethod"       = "S256"
  }
}

resource "keycloak_attribute_importer_identity_provider_mapper" "first_name_mapper" {
  realm                   = keycloak_realm.user.id
  name                    = "first-name-mapper"
  claim_name              = "name"
  identity_provider_alias = keycloak_oidc_identity_provider.one_identity_provider.alias
  user_attribute          = "firstName"

  # extra_config with syncMode is required in Keycloak 10+
  extra_config = {
    syncMode = "INHERIT"
  }
}

resource "keycloak_attribute_importer_identity_provider_mapper" "last_name_mapper" {
  realm                   = keycloak_realm.user.id
  name                    = "last-name-mapper"
  claim_name              = "familyName"
  identity_provider_alias = keycloak_oidc_identity_provider.one_identity_provider.alias
  user_attribute          = "lastName"

  # extra_config with syncMode is required in Keycloak 10+
  extra_config = {
    syncMode = "INHERIT"
  }
}

resource "keycloak_user_template_importer_identity_provider_mapper" "username_mapper" {
  realm                   = keycloak_realm.user.id
  name                    = "username-mapper"
  identity_provider_alias = keycloak_oidc_identity_provider.one_identity_provider.alias
  template                = "$${CLAIM.email}"

  # extra_config with syncMode is required in Keycloak 10+
  extra_config = {
    syncMode = "INHERIT"
    target   = "BROKER_ID"
  }
}

resource "keycloak_attribute_importer_identity_provider_mapper" "email_mapper" {
  realm                   = keycloak_realm.user.id
  name                    = "email-mapper"
  claim_name              = "email"
  identity_provider_alias = keycloak_oidc_identity_provider.one_identity_provider.alias
  user_attribute          = "email"

  # extra_config with syncMode is required in Keycloak 10+
  extra_config = {
    syncMode = "INHERIT"
  }
}

resource "keycloak_attribute_importer_identity_provider_mapper" "fiscal_number_mapper" {
  realm                   = keycloak_realm.user.id
  name                    = "fiscal-number-mapper"
  claim_name              = "fiscalNumber"
  identity_provider_alias = keycloak_oidc_identity_provider.one_identity_provider.alias
  user_attribute          = "fiscalNumber"

  # extra_config with syncMode is required in Keycloak 10+
  extra_config = {
    syncMode = "INHERIT"
  }
}

resource "keycloak_realm_user_profile" "user_profile" {
  realm_id = keycloak_realm.user.id

  unmanaged_attribute_policy = "ENABLED"

  attribute {
    name         = "username"
    display_name = "Username"

    multi_valued = false

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }
  }

  attribute {
    name         = "email"
    display_name = "Email"

    multi_valued = false

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }
  }

  attribute {
    name         = "firstName"
    display_name = "First Name"

    multi_valued = false

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }
  }

  attribute {
    name         = "lastName"
    display_name = "Last Name"

    multi_valued = false

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }
  }


  attribute {
    name         = "fiscalNumber"
    display_name = "Fiscal Number"

    multi_valued = false

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

  }

  attribute {
    name         = "dateOfBirth"
    display_name = "Date Of Birth"

    multi_valued = false

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

  }
}

# Client Scope dedicated per fiscalNumber
resource "keycloak_openid_client_scope" "fiscal_number_scope" {
  realm_id    = keycloak_realm.user.id
  name        = "fiscal-number-scope"
  description = "Scope to expose fiscalNumber claim"
}

# Mapper per fiscalNumber into scope
resource "keycloak_openid_user_attribute_protocol_mapper" "fiscal_number_mapper" {
  realm_id            = keycloak_realm.user.id
  client_scope_id     = keycloak_openid_client_scope.fiscal_number_scope.id
  name                = "fiscalNumber"
  user_attribute      = "fiscalNumber"
  claim_name          = "fiscalNumber"
  claim_value_type    = "String"
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true

  depends_on = [keycloak_realm_user_profile.user_profile, keycloak_openid_client_scope.fiscal_number_scope]
}

# Client Scope dedicated for dateOfBirth
resource "keycloak_openid_client_scope" "date_of_birth_scope" {
  realm_id    = keycloak_realm.user.id
  name        = "date-of-birth-scope"
  description = "Scope to expose dateOfBirth claim"
}

# Mapper for dateOfBirth into scope
resource "keycloak_openid_user_attribute_protocol_mapper" "date_of_birth_mapper" {
  realm_id            = keycloak_realm.user.id
  client_scope_id     = keycloak_openid_client_scope.date_of_birth_scope.id
  name                = "dateOfBirth"
  user_attribute      = "dateOfBirth"
  claim_name          = "dateOfBirth"
  claim_value_type    = "String"
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true

  depends_on = [keycloak_realm_user_profile.user_profile, keycloak_openid_client_scope.date_of_birth_scope]
}
