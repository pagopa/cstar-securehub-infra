# Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.product}-adgroup-admin"
}

data "azuread_group" "adgroup_developers" {
  display_name = "${local.product}-adgroup-developers"
}

data "azuread_group" "adgroup_externals" {
  display_name = "${local.product}-adgroup-externals"
}

data "azuread_group" "adgroup_security" {
  display_name = "${local.product}-adgroup-security"
}

# Start Keycloak
# tutti i secret e
data "azurerm_key_vault" "key_vault_core" {
  name                = local.kv_core_name
  resource_group_name = local.kv_core_resource_group_name
}


data "azurerm_key_vault_secret" "postgres_admin_username" {
  name         = "postgres-admin-username"
  key_vault_id = data.azurerm_key_vault.key_vault_core.id
}

data "azurerm_key_vault_secret" "postgres_admin_password" {
  name         = "postgres-admin-password"
  key_vault_id = data.azurerm_key_vault.key_vault_core.id
}

resource "kubernetes_config_map" "keycloak-config" {
  metadata {
    name      = "keycloak-config"
    namespace = kubernetes_namespace.keycloak.metadata[0].name
  }

  data = {
    kc-db-schema = "public",
    kc-db-url-port = "5432",
    kc-db = "postgres"
  }
}
# Stop Keycloak


