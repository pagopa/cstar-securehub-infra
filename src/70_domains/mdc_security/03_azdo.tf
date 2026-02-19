resource "azurerm_key_vault_access_policy" "azdevops_iac_managed_identities_read_only" {
  for_each = {
    for i in flatten([
      for kv in local.secrets_folders_kv : [
        for identity in local.azdo_iac_managed_identities_read : {
          kv_key       = kv
          identity_key = identity
        }
      ]
    ]) : "${i.kv_key}.${i.identity_key}" => i
  }

  key_vault_id = module.key_vault[each.value.kv_key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_user_assigned_identity.iac_federated_azdo[each.value.identity_key].principal_id

  key_permissions    = ["Get", "List", "Decrypt", "Encrypt", "Verify", "GetRotationPolicy", "Recover"]
  secret_permissions = ["Get", "List", "Set"]
}

resource "azurerm_key_vault_access_policy" "azdevops_iac_managed_identities_write" {
  for_each = {
    for i in flatten([
      for kv in local.secrets_folders_kv : [
        for identity in local.azdo_iac_managed_identities_write : {
          kv_key       = kv
          identity_key = identity
        }
      ]
    ]) : "${i.kv_key}.${i.identity_key}" => i
  }

  key_vault_id = module.key_vault[each.value.kv_key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_user_assigned_identity.iac_federated_azdo[each.value.identity_key].principal_id

  key_permissions    = ["Get", "List", "Decrypt", "Encrypt", "Verify", "GetRotationPolicy", "Recover"]
  secret_permissions = ["Get", "List", "Set", "Delete", "Recover"]
}
