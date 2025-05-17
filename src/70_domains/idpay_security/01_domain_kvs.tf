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

  tags = var.tags
}

#
# KV Policy using the new module
module "key_vault_policy_admin" {
  source          = "../../modules/key_vault_policy"
  for_each        = toset(local.secrets_folders_kv)
  permission_type = "admin"
  env             = var.env
  key_vault_id    = module.key_vault[each.key].id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  object_id       = data.azuread_group.adgroup_admin.object_id
}

module "key_vault_policy_developer" {
  source          = "../../modules/key_vault_policy"
  for_each        = toset(local.secrets_folders_kv)
  permission_type = "developer"
  env             = var.env
  key_vault_id    = module.key_vault[each.key].id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  object_id       = data.azuread_group.adgroup_developers.object_id
}

module "key_vault_policy_external" {
  source          = "../../modules/key_vault_policy"
  for_each        = var.env == "dev" ? toset(local.secrets_folders_kv) : []
  permission_type = "external"
  env             = var.env
  key_vault_id    = module.key_vault[each.key].id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  object_id       = data.azuread_group.adgroup_externals.object_id
}

module "key_vault_policy_apim_managed_identity" {
  source          = "../../modules/key_vault_policy"
  for_each        = toset(local.secrets_folders_kv)
  permission_type = "reader"
  env             = var.env
  key_vault_id    = module.key_vault[each.key].id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  object_id       = data.azurerm_api_management.apim.identity[0].principal_id
}
