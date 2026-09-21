module "key_vault" {
  source = "./.terraform/modules/__v4__/IDH/key_vault"

  name                = "${local.project}-kv"
  product_name        = var.prefix
  env                 = var.env
  location            = var.location
  idh_resource_tier   = "standard_public"
  resource_group_name = "${local.project}-security-rg"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  tags = module.tag_config.tags
}


module "key_vault_permission" {
  source   = "./.terraform/modules/__v4__/IDH/key_vault_access_policy"
  for_each = local.ad_groups

  product_name      = var.prefix
  idh_resource_tier = each.value.type
  env               = var.env
  key_vault_id      = module.key_vault.id
  tenant_id         = data.azurerm_client_config.current.tenant_id
  object_id         = data.azuread_group.ad_groups[each.key].object_id

}

resource "azurerm_role_assignment" "kv_group_roles" {
  for_each = local.ad_groups

  scope                = module.key_vault.id
  role_definition_name = each.value.rbac_role
  principal_id         = data.azuread_group.ad_groups[each.key].object_id
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "ad_group_policy" {
  key_vault_id = module.key_vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_admin.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Encrypt", "Decrypt", "Backup", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Backup", "Purge", "Recover", "Restore"]
  storage_permissions     = []
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover", ]
}
