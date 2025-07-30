#
# Kv + Policy
#
module "key_vault" {
  source = "./.terraform/modules/__v4__/IDH/key_vault"

  for_each = toset(local.secrets_folders_kv)

  name                = "${local.project_nodomain}-mc-${each.key}-kv"
  idh_resource_tier   = var.env_short != "p" ? "standard_private" : "premium_private"
  product_name        = "cstar"
  env                 = var.env
  location            = var.location
  resource_group_name = local.security_rg
  tenant_id           = data.azurerm_client_config.current.tenant_id

  private_endpoint_enabled             = true
  private_endpoint_resource_group_name = local.security_rg
  private_dns_zones_ids                = [data.azurerm_private_dns_zone.key_vault.id]
  private_endpoint_subnet_id           = module.private_endpoint_kv_snet.id

  tags = module.tag_config.tags
}

#
# KV Policy
#
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
  source = "./.terraform/modules/__v4__/IDH/key_vault_access_policy"

  for_each = toset(local.secrets_folders_kv)

  product_name      = "cstar"
  idh_resource_tier = "developer"
  env               = var.env
  key_vault_id      = module.key_vault[each.key].id
  tenant_id         = data.azurerm_client_config.current.tenant_id
  object_id         = data.azuread_group.adgroup_developers.object_id
}

module "externals_policy" {
  source = "./.terraform/modules/__v4__/IDH/key_vault_access_policy"

  for_each = var.env == "dev" ? toset(local.secrets_folders_kv) : []

  product_name      = "cstar"
  idh_resource_tier = "external"
  env               = var.env
  key_vault_id      = module.key_vault[each.key].id
  tenant_id         = data.azurerm_client_config.current.tenant_id
  object_id         = data.azuread_group.adgroup_externals.object_id
}
