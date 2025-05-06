#
# Storage for refunds API
#
#tfsec:ignore:azure-storage-default-action-deny
module "idpay_refund_storage" {
  source = "./.terraform/modules/__v4__/storage_account"

  name                            = replace("${local.project}-refund-sa", "-", "")
  resource_group_name             = data.azurerm_resource_group.idpay_data_rg.name
  location                        = var.location
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
  subnet_id                 = data.azurerm_subnet.private_endpoint_subnet.id

  tags = var.tags
}

#
# Containers
#

locals {
  idpay_containers = [
    "refund",
    "merchant"
  ]
}

resource "azurerm_storage_container" "idpay" {
  for_each              = toset(local.idpay_containers)
  name                  = each.value
  storage_account_id    = module.idpay_refund_storage.id
  container_access_type = "private"
}

#
# 🔑 Secrets
#
locals {
  refund_secrets = {
    "refund-storage-access-key"            = module.idpay_refund_storage.primary_access_key
    "refund-storage-connection-string"     = module.idpay_refund_storage.primary_connection_string
    "refund-storage-blob-connection-string" = module.idpay_refund_storage.primary_blob_connection_string
  }
}

resource "azurerm_key_vault_secret" "refund" {
  for_each     = local.refund_secrets

  name         = each.key
  value        = each.value
  content_type = "text/plain"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}
