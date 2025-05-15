#
# Storage for Initiative Data (i.e. Logo)
#

module "idpay_initiative_storage" {

  source = "./.terraform/modules/__v4__/storage_account"

  name                = replace("${local.project}-initatv-sa", "-", "")
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  location            = var.location

  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = var.storage_account_settings.replication_type
  access_tier                     = "Hot"
  blob_versioning_enabled         = var.storage_account_settings.enable_versioning
  advanced_threat_protection      = var.storage_account_settings.advanced_threat_protection_enabled
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false

  blob_delete_retention_days = var.storage_account_settings.delete_retention_days

  private_endpoint_enabled  = true
  private_dns_zone_blob_ids = [data.azurerm_private_dns_zone.storage_account_blob.id]
  subnet_id                 = module.idpay_storage_snet.id

  tags = var.tags
}

#
# Containers
#
locals {
  idpay_initiative_containers = {
    logo    = "private"
    ranking = "private"
  }
}

resource "azurerm_storage_container" "idpay_initiative" {
  for_each              = local.idpay_initiative_containers
  name                  = each.key
  container_access_type = each.value
  storage_account_id    = module.idpay_initiative_storage.id
}

#
# Policies
#
resource "azurerm_role_assignment" "initiative_storage_data_contributor" {
  scope                = module.idpay_initiative_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_api_management.apim_core.identity[0].principal_id

  depends_on = [
    module.idpay_initiative_storage
  ]
}

#
# 🔑 Secrets
#
locals {
  initiative_secrets = {
    "initiative-storage-access-key"             = module.idpay_initiative_storage.primary_access_key
    "initiative-storage-connection-string"      = module.idpay_initiative_storage.primary_connection_string
    "initiative-storage-blob-connection-string" = module.idpay_initiative_storage.primary_blob_connection_string
  }
}

resource "azurerm_key_vault_secret" "initiative_secrets" {
  for_each = local.initiative_secrets

  name         = each.key
  value        = each.value
  content_type = "text/plain"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}
