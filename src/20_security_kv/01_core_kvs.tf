resource "azurerm_resource_group" "sec_rg" {
  name     = "${local.project_nodomain}-core-sec-rg"
  location = var.location

  tags = var.tags
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

  tags = var.tags
}

# Admin access for admin group (all environments)
module "admin_access" {
  source = "../../modules/keyvault_access_policy"
  
  for_each = toset(local.prefix_key_vaults)
  
  key_vault_id        = module.key_vault[each.key].id
  object_ids          = [data.azuread_group.adgroup_admin.object_id]
  policies_environment = var.env
  role                = "admin"
}

# Developer access (permissions vary by environment)
module "developer_access" {
  source = "../../modules/keyvault_access_policy"
  
  for_each = toset(local.prefix_key_vaults)
  
  key_vault_id        = module.key_vault[each.key].id
  object_ids          = [data.azuread_group.adgroup_developers.object_id]
  policies_environment = var.env
  role                = "developer"
}

# External access (development only)
module "external_access" {
  source = "../../modules/keyvault_access_policy"
  
  for_each = var.env == "dev" ? toset(local.prefix_key_vaults) : []
  
  key_vault_id        = module.key_vault[each.key].id
  object_ids          = [data.azuread_group.adgroup_externals.object_id]
  policies_environment = var.env
  role                = "readonly"
}


