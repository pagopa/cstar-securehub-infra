#
# Azdo managed identity
#

resource "azurerm_key_vault_access_policy" "azdo_managed_identity" {
  for_each = toset(local.secrets_folders_kv)

  key_vault_id = module.key_vault[each.key].id
  tenant_id    = data.azurerm_user_assigned_identity.azdo_managed_identity.tenant_id
  object_id    = data.azurerm_user_assigned_identity.azdo_managed_identity.principal_id

  secret_permissions = ["Get", "List"]
}
