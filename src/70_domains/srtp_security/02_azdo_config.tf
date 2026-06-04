resource "azurerm_key_vault_access_policy" "azdevops_iac_managed_identities_read_only" {
  for_each = local.azdo_iac_read_kv

  key_vault_id = module.key_vault[each.value.kv].id
  tenant_id    = data.azurerm_user_assigned_identity.iac_federated_azdo[each.value.identity].tenant_id
  object_id    = data.azurerm_user_assigned_identity.iac_federated_azdo[each.value.identity].principal_id

  key_permissions         = ["Get", "List", "GetRotationPolicy", "Decrypt"]
  secret_permissions      = ["Get", "List"]
  certificate_permissions = ["List", "Get"]
}

resource "azurerm_key_vault_access_policy" "azdevops_iac_managed_identities_write" {
  for_each = local.azdo_iac_write_kv

  key_vault_id = module.key_vault[each.value.kv].id
  tenant_id    = data.azurerm_user_assigned_identity.iac_federated_azdo[each.value.identity].tenant_id
  object_id    = data.azurerm_user_assigned_identity.iac_federated_azdo[each.value.identity].principal_id

  key_permissions         = ["Get", "List", "Decrypt", "Encrypt", "Verify", "GetRotationPolicy", "Recover"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover"]
  certificate_permissions = ["List", "Get"]
}
