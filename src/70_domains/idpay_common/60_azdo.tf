resource "azurerm_key_vault_access_policy" "azdevops_iac_managed_identities" {
  for_each = local.azdo_iac_managed_identities

  key_vault_id = data.azurerm_key_vault.domain_kv.id
  tenant_id    = data.azurerm_key_vault.domain_kv.tenant_id
  object_id    = data.azurerm_user_assigned_identity.iac_federated_azdo[each.key].principal_id

  key_permissions    = ["Get", "List", "Decrypt", "Encrypt", "Verify", "GetRotationPolicy", "Recover"]
  secret_permissions = ["Get", "List", "Set"]

  certificate_permissions = ["List", "Get"]

  storage_permissions = []
}
