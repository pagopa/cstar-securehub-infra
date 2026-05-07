##################
# Realms: User
##################

module "keycloak_setup" {
  source = "./.terraform/modules/__v4__/keycloak_realms_setup"

  domain = var.domain

  realms_configuration = [
    {
      name         = "test-1",
      display_name = "TEST 1",
      description  = "Test 1"
      enabled      = true
    },
    {
      name         = "test-2",
      display_name = "TEST 2",
      description  = "Test 2"
      enabled      = true
    }
  ]

  key_vault_rg   = local.idpay_kv_rg_name
  key_vault_name = data.azurerm_key_vault.domain_kv.name

  admin_entra_group_ids = concat(
    var.env_short != "p" ? [data.azuread_group.adgroup_domain_externals.object_id, data.azuread_group.adgroup_domain_developers.object_id] : [],
    [
      data.azuread_group.adgroup_domain_admin.object_id
    ]
  )

  viewer_entra_group_ids = [
    data.azuread_group.adgroup_domain_project_managers.object_id
  ]
  tags = module.tag_config.tags
}

data "keycloak_openid_client" "management_client" {
  for_each = { for i in local.keycloak_realm : i.realm => i }

  realm_id  = "master"
  client_id = "${each.key}-realm"

  depends_on = [keycloak_realm.user]
}

data "keycloak_role" "user_manage_users" {
  for_each = { for i in local.keycloak_realm : i.realm => i }

  realm_id  = "master"
  client_id = data.keycloak_openid_client.management_client[each.key].id
  name      = "manage-users"
}

data "keycloak_role" "user_manage_clients" {
  for_each = { for i in local.keycloak_realm : i.realm => i }

  realm_id  = "master"
  client_id = data.keycloak_openid_client.management_client[each.key].id
  name      = "manage-clients"
}

data "keycloak_role" "user_manage_events" {
  for_each = { for i in local.keycloak_realm : i.realm => i }

  realm_id  = "master"
  client_id = data.keycloak_openid_client.management_client[each.key].id
  name      = "manage-events"
}

data "keycloak_role" "user_view_realm" {
  for_each = { for i in local.keycloak_realm : i.realm => i }

  realm_id  = "master"
  client_id = data.keycloak_openid_client.management_client[each.key].id
  name      = "view-realm"
}

data "keycloak_role" "user_view_users" {
  for_each = { for i in local.keycloak_realm : i.realm => i }

  realm_id  = "master"
  client_id = data.keycloak_openid_client.management_client[each.key].id
  name      = "view-users"
}

data "keycloak_role" "user_query_groups" {
  for_each = { for i in local.keycloak_realm : i.realm => i }

  realm_id  = "master"
  client_id = data.keycloak_openid_client.management_client[each.key].id
  name      = "query-groups"
}

data "keycloak_role" "user_query_users" {
  for_each = { for i in local.keycloak_realm : i.realm => i }

  realm_id  = "master"
  client_id = data.keycloak_openid_client.management_client[each.key].id
  name      = "query-users"
}

data "keycloak_role" "user_query_clients" {
  for_each = { for i in local.keycloak_realm : i.realm => i }

  realm_id  = "master"
  client_id = data.keycloak_openid_client.management_client[each.key].id
  name      = "query-clients"
}

data "keycloak_role" "user_view_clients" {
  for_each  = { for i in local.keycloak_realm : i.realm => i }
  realm_id  = "master"
  client_id = data.keycloak_openid_client.management_client[each.key].id
  name      = "view-clients"
}

data "keycloak_role" "user_view_events" {
  for_each  = { for i in local.keycloak_realm : i.realm => i }
  realm_id  = "master"
  client_id = data.keycloak_openid_client.management_client[each.key].id
  name      = "view-events"
}

resource "keycloak_role" "domain_admin_role" {
  for_each = { for i in local.keycloak_realm : i.realm => i }

  realm_id    = "master"
  name        = "${var.domain}_${each.key}-realm_domain-admin-role"
  description = "Minimal admin: users, clients, events"

  composite_roles = [
    data.keycloak_role.user_manage_users[each.key].id,
    data.keycloak_role.user_manage_clients[each.key].id,
    data.keycloak_role.user_manage_events[each.key].id,
    data.keycloak_role.user_view_realm[each.key].id,
    data.keycloak_role.user_view_users[each.key].id,
    data.keycloak_role.user_query_groups[each.key].id,
    data.keycloak_role.user_query_users[each.key].id,
    data.keycloak_role.user_query_clients[each.key].id,
    data.keycloak_role.user_view_clients[each.key].id,
    data.keycloak_role.user_view_events[each.key].id
  ]
}

resource "keycloak_role" "domain_view_role" {
  for_each = { for i in local.keycloak_realm : i.realm => i }

  realm_id    = "master"
  name        = "${var.domain}_${each.key}-realm_domain-viewer-role"
  description = "Viewer"

  composite_roles = [
    data.keycloak_role.user_view_realm[each.key].id,
    data.keycloak_role.user_view_users[each.key].id,
    data.keycloak_role.user_query_groups[each.key].id,
    data.keycloak_role.user_query_users[each.key].id,
    data.keycloak_role.user_query_clients[each.key].id,
    data.keycloak_role.user_view_clients[each.key].id,
    data.keycloak_role.user_view_events[each.key].id
  ]
}

resource "keycloak_custom_identity_provider_mapper" "domain_admin_realm_mapper" {
  for_each = { for i in local.keycloak_realm : i.realm => i }

  realm                    = "master"
  name                     = "${var.domain}-${each.key}-realm.entra-domain-admin"
  identity_provider_alias  = "azure-entra"
  identity_provider_mapper = "oidc-role-idp-mapper"

  extra_config = {
    syncMode      = "FORCE"
    claim         = "groups"
    "claim.value" = data.azuread_group.adgroup_domain_admin.object_id
    role          = keycloak_role.domain_admin_role[each.key].name
  }
}

resource "keycloak_custom_identity_provider_mapper" "domain_developers_realm_mapper" {
  for_each = var.env_short != "p" ? { for i in local.keycloak_realm : i.realm => i } : {}

  realm                    = "master"
  name                     = "${var.domain}-${each.key}-realm.entra-domain-developers"
  identity_provider_alias  = "azure-entra"
  identity_provider_mapper = "oidc-role-idp-mapper"

  extra_config = {
    syncMode      = "FORCE"
    claim         = "groups"
    "claim.value" = data.azuread_group.adgroup_domain_developers.object_id
    role          = keycloak_role.domain_admin_role[each.key].name
  }
}

resource "keycloak_custom_identity_provider_mapper" "domain_externals_realm_mapper" {
  for_each = var.env_short != "p" ? { for i in local.keycloak_realm : i.realm => i } : {}

  realm                    = "master"
  name                     = "${var.domain}-${each.key}-realm.entra-domain-externals"
  identity_provider_alias  = "azure-entra"
  identity_provider_mapper = "oidc-role-idp-mapper"

  extra_config = {
    syncMode      = "FORCE"
    claim         = "groups"
    "claim.value" = data.azuread_group.adgroup_domain_externals.object_id
    role          = keycloak_role.domain_view_role[each.key].name
  }
}
