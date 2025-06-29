#
# Storage for refunds API
#

module "storage_idpay_refund" {
  source = "./.terraform/modules/__v4__/IDH/storage_account"

  # General
  product_name        = var.prefix
  env                 = var.env
  location            = var.location
  resource_group_name = local.data_rg
  tags                = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = var.env_short != "prod" ? "basic" : "??"

  # Storage Account Settings
  name   = replace("${local.project}-refund-sa", "-", "")
  domain = var.domain

  # Network
  private_dns_zone_blob_ids  = [data.azurerm_private_dns_zone.blob_storage.id]
  private_endpoint_subnet_id = module.private_endpoint_storage_snet.id

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
  storage_account_id    = module.storage_idpay_refund.id
  container_access_type = "private"
}

#
# 🔑 Secrets
#
locals {
  refund_secrets = {
    "refund-storage-access-key"             = module.storage_idpay_refund.primary_access_key
    "refund-storage-connection-string"      = module.storage_idpay_refund.primary_connection_string
    "refund-storage-blob-connection-string" = module.storage_idpay_refund.primary_blob_connection_string
  }
}

resource "azurerm_key_vault_secret" "refund" {
  for_each = local.refund_secrets

  name         = each.key
  value        = each.value
  content_type = "text/plain"
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  tags = module.tag_config.tags
}
