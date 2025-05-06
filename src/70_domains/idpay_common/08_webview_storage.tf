#tfsec:ignore:azure-storage-default-action-deny
module "idpay_webview_storage" {
  source = "./.terraform/modules/__v4__/storage_account"

  name                            = replace("${local.project}-webview-sa", "-", "")
  resource_group_name             = data.azurerm_resource_group.idpay_data_rg.name
  location                        = var.location

  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  access_tier                     = "Hot"
  account_replication_type        = var.storage_account_settings.replication_type
  blob_versioning_enabled         = var.storage_account_settings.enable_versioning
  advanced_threat_protection      = var.storage_account_settings.advanced_threat_protection_enabled
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false

  blob_delete_retention_days = var.storage_account_settings.delete_retention_days

  private_endpoint_enabled  = true
  private_dns_zone_blob_ids = [data.azurerm_private_dns_zone.storage_account_blob.id]
  subnet_id                 = data.azurerm_subnet.private_endpoint_subnet.id

  tags = var.tags
}

#
# Containers
#
resource "azurerm_storage_container" "idpay_webview_container" {
  name                  = "webview"
  storage_account_id    = module.idpay_webview_storage.id
  container_access_type = "private"
}

#
# Roles
#
resource "azurerm_role_assignment" "webview_storage_data_contributor" {
  scope                = module.idpay_webview_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_api_management.apim_core.identity[0].principal_id

  depends_on = [
    module.idpay_webview_storage
  ]
}

#
# 🔑 Secrets
#
locals {
  webview_secrets = {
    "webview-storage-access-key"        = module.idpay_webview_storage.primary_access_key
    "webview-storage-connection-string" = module.idpay_webview_storage.primary_connection_string
  }
}

resource "azurerm_key_vault_secret" "webview" {
  for_each     = local.webview_secrets

  name         = each.key
  value        = each.value
  content_type = "text/plain"
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  #tfsec:ignore:azure-keyvault-ensure-secret-expiry
}
