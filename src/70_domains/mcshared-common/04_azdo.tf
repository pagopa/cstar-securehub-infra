resource "azurerm_key_vault_access_policy" "azdevops_iac_managed_identities" {
  for_each = local.kv_identity

  key_vault_id = each.value.kv_id
  tenant_id    = each.value.tenant_id
  object_id    = each.value.object_id

  key_permissions    = ["Get", "List", "Decrypt", "Encrypt", "Verify", "GetRotationPolicy"]
  secret_permissions = ["Get", "List", "Set"]

  certificate_permissions = ["List", "Get"]

  storage_permissions = []
}
