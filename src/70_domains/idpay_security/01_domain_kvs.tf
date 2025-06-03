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
# KV Policy
#
module "admins_policy" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//IDH/key_vault_access_policy?ref=PAYMCLOUD-422-idh-kv-access-policy-configurator"

  for_each = toset(local.secrets_folders_kv)

  prefix          = "cstar"
  permission_tier = "admin" # or developer, external
  env             = var.env # or prod, uat, etc.
  key_vault_id    = module.key_vault[each.key].id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  object_id       = data.azuread_group.adgroup_admin.object_id
}

module "developers_policy" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//IDH/key_vault_access_policy?ref=PAYMCLOUD-422-idh-kv-access-policy-configurator"

  for_each = toset(local.secrets_folders_kv)

  prefix          = "cstar"
  permission_tier = "developer" # or developer, external
  env             = var.env     # or prod, uat, etc.
  key_vault_id    = module.key_vault[each.key].id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  object_id       = data.azuread_group.adgroup_developers.object_id
}

module "externals_policy" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//IDH/key_vault_access_policy?ref=PAYMCLOUD-422-idh-kv-access-policy-configurator"

  for_each = var.env == "dev" ? toset(local.secrets_folders_kv) : []

  prefix          = "cstar"
  permission_tier = "external" # or developer, external
  env             = var.env
  key_vault_id    = module.key_vault[each.key].id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  object_id       = data.azuread_group.adgroup_externals.object_id
}

#
# Managed identities
#
resource "azurerm_key_vault_access_policy" "apim_managed_identity" {
  for_each = toset(local.secrets_folders_kv)

  key_vault_id = module.key_vault[each.key].id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_api_management.apim.identity[0].principal_id

  key_permissions         = ["Get", "List"]
  secret_permissions      = ["Get", "List", ]
  storage_permissions     = []
  certificate_permissions = ["Get", "List", ]
}
