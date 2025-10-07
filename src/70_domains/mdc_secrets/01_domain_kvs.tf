#
# Kv + Policy
#

module "key_vault" {
  source = "./.terraform/modules/__v4__/key_vault"

  for_each = toset(local.secrets_folders_kv)

  name                          = "${local.project_nodomain}-${each.key}-kv"
  location                      = data.azurerm_resource_group.idpay_security_rg.location
  resource_group_name           = data.azurerm_resource_group.idpay_security_rg.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = var.env != "prod" ? 7 : 90
  public_network_access_enabled = true

  tags = module.tag_config.tags
}

#
# KV Policy
#
module "admins_policy" {
  source = "./.terraform/modules/__v4__/IDH/key_vault_access_policy"

  for_each = toset(local.secrets_folders_kv)

  product_name      = "cstar"
  idh_resource_tier = "admin" # or developer, external
  env               = var.env # or prod, uat, etc.
  key_vault_id      = module.key_vault[each.key].id
  tenant_id         = data.azurerm_client_config.current.tenant_id
  object_id         = data.azuread_group.adgroup_admin.object_id
}

module "developers_policy" {
  source = "./.terraform/modules/__v4__//IDH/key_vault_access_policy"

  for_each = toset(local.secrets_folders_kv)

  product_name      = "cstar"
  idh_resource_tier = "developer" # or developer, external
  env               = var.env     # or prod, uat, etc.
  key_vault_id      = module.key_vault[each.key].id
  tenant_id         = data.azurerm_client_config.current.tenant_id
  object_id         = data.azuread_group.adgroup_developers.object_id
}

module "externals_policy" {
  source = "./.terraform/modules/__v4__/IDH/key_vault_access_policy"

  for_each = var.env == "dev" ? toset(local.secrets_folders_kv) : []

  product_name      = "cstar"
  idh_resource_tier = "external" # or developer, external
  env               = var.env
  key_vault_id      = module.key_vault[each.key].id
  tenant_id         = data.azurerm_client_config.current.tenant_id
  object_id         = data.azuread_group.adgroup_externals.object_id
}
