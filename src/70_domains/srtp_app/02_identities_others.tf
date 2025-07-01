#------------------------------------------------------------------
# APIM
#------------------------------------------------------------------
resource "azurerm_role_assignment" "apim_blob_reader" {
  scope                = data.azurerm_storage_account.rtp_storage_account.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = data.azurerm_api_management.apim.identity[0].principal_id
}
