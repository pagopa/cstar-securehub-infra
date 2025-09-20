resource "azurerm_resource_group" "security" {
  name     = "${local.project}-sec-rg"
  location = var.location

  tags = local.tags
}

module "key_vault" {
  for_each = local.key_vaults

  source = "./.terraform/modules/__v4__/key_vault"

  name                       = each.value
  location                   = azurerm_resource_group.security.location
  resource_group_name        = azurerm_resource_group.security.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 90

  tags = local.tags
}

locals {
  key_vault_ids = { for key, kv in module.key_vault : key => kv.id }
}

resource "azurerm_key_vault_access_policy" "admins" {
  for_each = local.key_vault_ids

  key_vault_id = each.value
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_group.adgroup_admin.object_id

  key_permissions = [
    "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "GetRotationPolicy",
    "Import", "List", "Purge", "Recover", "Restore", "Rotate", "SetRotationPolicy",
    "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release"
  ]
  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]
  certificate_permissions = [
    "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List",
    "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "SetContacts",
    "SetIssuers", "Update"
  ]
  storage_permissions = []
}

resource "azurerm_key_vault_access_policy" "developers" {
  for_each = var.env_short != "p" ? local.key_vault_ids : {}

  key_vault_id = each.value
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_group.adgroup_developers.object_id

  key_permissions = [
    "Decrypt", "Encrypt", "Get", "GetRotationPolicy", "Import", "List", "Recover", "Rotate",
    "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"
  ]
  secret_permissions = [
    "Delete", "Get", "List", "Recover", "Set"
  ]
  certificate_permissions = [
    "Create", "Delete", "Get", "Import", "List", "Purge", "Recover", "Restore", "Update"
  ]
  storage_permissions = []
}

resource "azurerm_key_vault_access_policy" "externals" {
  for_each = var.env_short != "p" ? local.key_vault_ids : {}

  key_vault_id = each.value
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_group.adgroup_externals.object_id

  key_permissions = [
    "Decrypt", "Encrypt", "Get", "GetRotationPolicy", "Import", "List", "Update"
  ]
  secret_permissions = [
    "Delete", "Get", "List", "Set"
  ]
  certificate_permissions = [
    "Create", "Delete", "Get", "Import", "List", "Purge", "Recover", "Restore", "Update"
  ]
  storage_permissions = []
}
