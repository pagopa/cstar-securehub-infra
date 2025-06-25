module "storage_idpay_merchants" {
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
  name   = replace("${local.project}-merchants-sa", "-", "")
  domain = var.domain

  # Network
  private_dns_zone_blob_ids  = [data.azurerm_private_dns_zone.blob_storage.id]
  private_endpoint_subnet_id = module.private_endpoint_storage_snet.id

}

#
# Containers
#
resource "azurerm_storage_container" "idpay_merchants_container" {
  name                  = "merchants"
  storage_account_id    = module.storage_idpay_merchants.id
  container_access_type = "private"
}

#
# Roles
#
resource "azurerm_role_assignment" "merchants_storage_data_contributor" {
  scope                = module.storage_idpay_merchants.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_api_management.apim_core.identity[0].principal_id

  depends_on = [
    module.storage_idpay_merchants
  ]
}

#
# 🔑 Secrets
#
locals {
  merchants_secrets = {
    "merchants-storage-access-key"        = module.storage_idpay_merchants.primary_access_key
    "merchants-storage-connection-string" = module.storage_idpay_merchants.primary_connection_string
  }
}

resource "azurerm_key_vault_secret" "merchants" {
  for_each = local.merchants_secrets

  name         = each.key
  value        = each.value
  content_type = "text/plain"
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  tags = module.tag_config.tags
}
