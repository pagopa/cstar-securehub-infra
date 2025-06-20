module "storage_idpay_webview" {
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
  name   = replace("${local.project}-webview-sa", "-", "")
  domain = var.domain

  # Network
  private_dns_zone_blob_ids  = [data.azurerm_private_dns_zone.blob_storage.id]
  private_endpoint_subnet_id = module.private_endpoint_storage_snet.id

}

#
# Containers
#
resource "azurerm_storage_container" "idpay_webview_container" {
  name                  = "webview"
  storage_account_id    = module.storage_idpay_webview.id
  container_access_type = "private"
}

#
# Roles
#
resource "azurerm_role_assignment" "webview_storage_data_contributor" {
  scope                = module.storage_idpay_webview.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_api_management.apim_core.identity[0].principal_id

  depends_on = [
    module.storage_idpay_webview
  ]
}

#
# 🔑 Secrets
#
locals {
  webview_secrets = {
    "webview-storage-access-key"        = module.storage_idpay_webview.primary_access_key
    "webview-storage-connection-string" = module.storage_idpay_webview.primary_connection_string
  }
}

resource "azurerm_key_vault_secret" "webview" {
  for_each = local.webview_secrets

  name         = each.key
  value        = each.value
  content_type = "text/plain"
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  tags = module.tag_config.tags
}
