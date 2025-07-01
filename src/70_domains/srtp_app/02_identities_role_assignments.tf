# # ------------------------------------------------------------------------------
# # Assignment of role "Key Vault Secrets Officer" on general key vault to
# # identity of rtp-activator microservice.
# # ------------------------------------------------------------------------------
# resource "azurerm_role_assignment" "secrets_user_on_domain_kv_to_activator_identity" {
#   scope                = data.azurerm_key_vault.kv_domain.id
#   role_definition_name = "Key Vault Secrets User"
#   principal_id         = azurerm_user_assigned_identity.activator.principal_id
# }
#
# # ------------------------------------------------------------------------------
# # Assignment of role "Reader" on blob storage to
# # identity of rtp-activator microservice.
# # ------------------------------------------------------------------------------
# resource "azurerm_role_assignment" "storage_account_to_activator_identity" {
#   scope                = data.azurerm_storage_account.rtp_blob_storage_account.id
#   role_definition_name = "Storage Blob Data Reader"
#   principal_id         = azurerm_user_assigned_identity.activator.principal_id
# }
#
#
#
# # ------------------------------------------------------------------------------
# # Assignment of role "Key Vault Secrets Officer" on general key vault to
# # identity of rtp-sender microservice.
# # ------------------------------------------------------------------------------
# resource "azurerm_role_assignment" "secrets_user_on_domain_kv_to_sender_identity" {
#   scope                = data.azurerm_key_vault.kv_domain.id
#   role_definition_name = "Key Vault Secrets User"
#   principal_id         = azurerm_user_assigned_identity.sender.principal_id
# }
#
# # ------------------------------------------------------------------------------
# # Assignment of role "Reader" on blob storage to
# # identity of rtp-sender microservice.
# # ------------------------------------------------------------------------------
# resource "azurerm_role_assignment" "storage_account_to_sender_identity" {
#   scope                = data.azurerm_storage_account.rtp_blob_storage_account.id
#   role_definition_name = "Storage Blob Data Reader"
#   principal_id         = azurerm_user_assigned_identity.sender.principal_id
# }
#
#
# resource "azurerm_role_assignment" "apim_blob_reader" {
#   scope                = data.azurerm_storage_account.rtp_blob_storage_account.id
#   role_definition_name = "Storage Blob Data Reader"
#   principal_id         = data.azurerm_api_management.apim_core.identity[0].principal_id
# }
