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
  idh_resource_tier = "basic_public"

  # Storage Account Settings
  name   = replace("${local.project}-refund-sa", "-", "")
  domain = var.domain

  # Network
  private_dns_zone_blob_ids  = [data.azurerm_private_dns_zone.blob_storage.id]
  private_endpoint_subnet_id = module.private_endpoint_storage_snet.id

  blob_cors_rule = {
    allowed_headers    = ["*"]
    exposed_headers    = ["*"]
    allowed_methods    = ["GET", "OPTIONS"]
    allowed_origins    = ["https://welfare.${data.azurerm_dns_zone.public_cstar.name}"]
    max_age_in_seconds = 200
  }

}

#
# Containers
#

locals {
  idpay_containers = [
    "refund",
    "merchant",
    "invoices",
    "reward-batches",
    "report-transactions"
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
    "refund-storage-account-name"           = module.storage_idpay_refund.name
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

#
# Roles Assignments for Workload Identity
#
resource "azurerm_role_assignment" "role_blob_storage_refund" {
  scope                = module.storage_idpay_refund.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.workload_identity_configuration_v2.workload_identity_principal_id
}

resource "azurerm_role_assignment" "refund_service_delegator_role" {
  scope                = module.storage_idpay_refund.id
  role_definition_name = "Storage Blob Delegator"
  principal_id         = module.workload_identity_configuration_v2.workload_identity_principal_id
}
