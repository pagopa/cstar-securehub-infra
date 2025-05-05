#
# Storage for Initiative Data (i.e. Logo)


#tfsec:ignore:azure-storage-default-action-deny
module "idpay_initiative_storage" {

  source = "./.terraform/modules/__v4__/storage_account"

  name                            = replace("${var.domain}${var.env_short}-initiative-storage", "-", "")
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = var.storage_account_settings.replication_type
  access_tier                     = "Hot"
  blob_versioning_enabled         = var.storage_account_settings.enable_versioning
  resource_group_name             = azurerm_resource_group.rg_refund_storage.name
  location                        = var.location
  advanced_threat_protection      = var.storage_account_settings.advanced_threat_protection_enabled
  allow_nested_items_to_be_public = false

  blob_delete_retention_days    = var.storage_account_settings.delete_retention_days
  public_network_access_enabled = var.storage_account_settings.public_network_access_enabled

  private_endpoint_enabled  = var.storage_account_settings.private_endpoint_enabled
  private_dns_zone_blob_ids = [data.azurerm_private_dns_zone.storage_account.id]
  subnet_id                 = data.azurerm_subnet.private_endpoint_subnet.id


  tags = var.tags
}

resource "azurerm_storage_container" "idpay_logo_container" {
  name                  = "logo"
  storage_account_id    = module.idpay_initiative_storage.id
  container_access_type = "blob"
}

resource "azurerm_storage_container" "idpay_ranking_container" {
  name                  = "ranking"
  storage_account_id    = module.idpay_initiative_storage.id
  container_access_type = "private"
}


# storage access key

resource "azurerm_key_vault_secret" "initiative_storage_access_key" {
  name         = "initiative-storage-access-key"
  value        = module.idpay_initiative_storage.primary_access_key
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "initiative_storage_connection_string" {
  name         = "initiative-storage-connection-string"
  value        = module.idpay_initiative_storage.primary_connection_string
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "initiative_storage_blob_connection_string" {
  name         = "initiative-storage-blob-connection-string"
  value        = module.idpay_initiative_storage.primary_blob_connection_string
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

resource "azurerm_role_assignment" "initiative_storage_data_contributor" {
  scope                = module.idpay_initiative_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_api_management.apim_core.identity[0].principal_id

  depends_on = [
    module.idpay_initiative_storage
  ]
}
