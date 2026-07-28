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
