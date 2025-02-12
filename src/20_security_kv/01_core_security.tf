resource "azurerm_resource_group" "sec_rg" {
  name     = "${local.product_nodomain}-core-sec-rg"
  location = var.location

  tags = var.tags
}

#
# Kv + Policy
#

module "key_vault" {
  source = "./.terraform/modules/__v4__/key_vault"

  for_each = toset(local.core_key_vaults)

  name                          = "${local.product_nodomain}-${each.key}-kv"
  location                      = azurerm_resource_group.sec_rg.location
  resource_group_name           = azurerm_resource_group.sec_rg.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = var.env != "prod" ? 7 : 90
  public_network_access_enabled = true

  tags = var.tags
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "ad_group_policy" {
  for_each = toset(local.core_key_vaults)

  key_vault_id = module.key_vault[each.key].id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_admin.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "GetRotationPolicy", "Encrypt", "Decrypt"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Restore"]
  storage_permissions     = []
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover"]
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "adgroup_developers_policy" {
  for_each = var.env == "dev" ? toset(local.core_key_vaults) : []

  key_vault_id = module.key_vault[each.key].id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_developers.object_id

  key_permissions     = ["Get", "List", "Update", "Create", "Import", "Delete", ]
  secret_permissions  = ["Get", "List", "Set", "Delete", ]
  storage_permissions = []
  certificate_permissions = [
    "Get", "List", "Update", "Create", "Import",
    "Delete", "Restore", "Purge", "Recover"
  ]
}

resource "azurerm_key_vault_access_policy" "adgroup_externals_policy" {
  for_each = var.env == "dev" ? toset(local.core_key_vaults) : []

  key_vault_id = module.key_vault[each.key].id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_externals.object_id

  key_permissions         = ["Get", "List"]
  secret_permissions      = ["Get", "List", "Set", "Delete"]
  storage_permissions     = []
  certificate_permissions = ["Get", "List"]
}
