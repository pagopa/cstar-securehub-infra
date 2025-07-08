# ------------------------------------------------------------------------------
# Identity for rtp-activator microservice.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "activator" {
  resource_group_name = data.azurerm_resource_group.identities_rg.name
  location            = data.azurerm_resource_group.identities_rg.location
  name                = "${local.project}-activator-id"
  tags                = module.tag_config.tags
}

resource "azurerm_role_assignment" "secrets_user_on_domain_kv_to_activator_identity" {
  scope                = data.azurerm_key_vault.domain_kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.activator.principal_id
}

resource "azurerm_role_assignment" "storage_account_to_activator_identity" {
  scope                = data.azurerm_storage_account.rtp_storage_account.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.activator.principal_id
}

# ------------------------------------------------------------------------------
# Identity for rtp-sender microservice.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "sender" {
  resource_group_name = data.azurerm_resource_group.identities_rg.name
  location            = data.azurerm_resource_group.identities_rg.location
  name                = "${local.project}-sender-id"
  tags                = module.tag_config.tags
}

resource "azurerm_key_vault_access_policy" "access_policy_auth_kv" {

  key_vault_id = data.azurerm_key_vault.domain_kv.id
  tenant_id    = data.azurerm_key_vault.domain_kv.tenant_id
  object_id    = azurerm_user_assigned_identity.sender.principal_id

  secret_permissions = ["Get", "List", "Set", "Delete"]
}

resource "azurerm_role_assignment" "storage_account_to_sender_identity" {
  scope                = data.azurerm_storage_account.rtp_storage_account.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.sender.principal_id
}
