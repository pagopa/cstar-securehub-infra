# ------------------------------------------------------------------------------
# Identity for auth microservice.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "auth" {
  resource_group_name = local.security_rg_name
  location            = var.location
  name                = "${local.project}-auth-id"

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_access_policy" "access_policy_auth_kv" {

  key_vault_id = data.azurerm_key_vault.auth_general_kv.id
  tenant_id    = data.azurerm_key_vault.auth_general_kv.tenant_id
  object_id    = azurerm_user_assigned_identity.auth.principal_id

  key_permissions = [
    "Get", "List", "Update", "Delete", "Create", "Recover", "Sign", "Verify"
  ]

}
