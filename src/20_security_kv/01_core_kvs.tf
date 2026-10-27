resource "azurerm_resource_group" "sec_rg" {
  name     = "${local.project_nodomain}-core-sec-rg"
  location = var.location

  tags = module.tag_config.tags
}

#
# Kv + Policy
#

module "key_vault" {
  source = "./.terraform/modules/__v4__/key_vault"

  for_each = toset(local.prefix_key_vaults)

  name                          = "${local.project_nodomain}-${each.key}-kv"
  location                      = azurerm_resource_group.sec_rg.location
  resource_group_name           = azurerm_resource_group.sec_rg.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = var.env != "prod" ? 7 : 90
  public_network_access_enabled = true

  tags = module.tag_config.tags
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "ad_group_policy" {
  for_each = toset(local.prefix_key_vaults)

  key_vault_id = module.key_vault[each.key].id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_admin.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "GetRotationPolicy", "SetRotationPolicy", "Encrypt", "Decrypt"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Restore"]
  storage_permissions     = []
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover"]
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "adgroup_developers_policy" {
  for_each = contains(["d", "u"], var.env_short) ? toset(local.prefix_key_vaults) : []

  key_vault_id = module.key_vault[each.key].id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_developers.object_id

  key_permissions = [
    "Get", "List", "Update", "Create", "Import", "Delete",
    "Rotate", "GetRotationPolicy", "SetRotationPolicy",
    "Encrypt", "Decrypt", "Recover", "Backup", "Restore"
  ]
  secret_permissions  = ["Get", "List", "Set", "Delete", "Recover"]
  storage_permissions = []
  certificate_permissions = [
    "Get", "List", "Update", "Create", "Import",
    "Delete", "Restore", "Purge", "Recover"
  ]
}

resource "azurerm_key_vault_access_policy" "adgroup_developers_policy_cicd" {
  count = var.env_short == "p" ? 1 : 0

  key_vault_id = module.key_vault["cicd"].id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_developers.object_id

  key_permissions         = []
  secret_permissions      = ["Get", "List"]
  storage_permissions     = []
  certificate_permissions = []
}


resource "azurerm_key_vault_access_policy" "adgroup_externals_policy" {
  for_each = var.env == "dev" ? toset(local.prefix_key_vaults) : []

  key_vault_id = module.key_vault[each.key].id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_externals.object_id

  key_permissions         = ["Get", "List"]
  secret_permissions      = ["Get", "List", "Set", "Delete"]
  storage_permissions     = []
  certificate_permissions = ["Get", "List"]
}

module "domain_admins_reader_policy_core" {
  source = "./.terraform/modules/__v4__/IDH/key_vault_access_policy"

  for_each = { for group in local.domain_ad_group_rbac : group.object_id => group }

  product_name      = "cstar"
  idh_resource_tier = "reader"
  env               = var.env
  key_vault_id      = module.key_vault["core"].id
  tenant_id         = data.azurerm_client_config.current.tenant_id
  object_id         = each.value.object_id
}

resource "azurerm_role_assignment" "domain_kv_reader_core" {
  for_each = { for group in local.domain_ad_group_rbac : group.object_id => group }

  scope                = module.key_vault["core"].id
  role_definition_name = "Key Vault Reader"
  principal_id         = each.value.object_id
}

module "domain_admins_reader_policy_cicd" {
  source = "./.terraform/modules/__v4__/IDH/key_vault_access_policy"

  for_each = { for group in local.domain_ad_group_rbac : group.object_id => group }

  product_name      = "cstar"
  idh_resource_tier = "reader"
  env               = var.env
  key_vault_id      = module.key_vault["cicd"].id
  tenant_id         = data.azurerm_client_config.current.tenant_id
  object_id         = each.value.object_id
}

resource "azurerm_role_assignment" "domain_kv_reader_cicd" {
  for_each = { for group in local.domain_ad_group_rbac : group.object_id => group }

  scope                = module.key_vault["cicd"].id
  role_definition_name = "Key Vault Reader"
  principal_id         = each.value.object_id
}
