
module "storage_idpay_exports" {
  source              = "./.terraform/modules/__v4__/IDH/storage_account"
  product_name        = var.prefix
  env                 = var.env
  location            = var.location
  resource_group_name = local.data_rg
  tags                = module.tag_config.tags

  # Basic for non-prod, Standard for prod
  idh_resource_tier = var.env_short != "p" ? "basic" : "standard"

  # Module creates the storage account (keep the same name you already use)
  name   = replace("${local.project}-exports-sa", "-", "")
  domain = var.domain

  # Private networking from the module (kept as-is)
  private_dns_zone_blob_ids  = [data.azurerm_private_dns_zone.blob_storage.id]
  private_endpoint_subnet_id = module.private_endpoint_storage_snet.id
}

# Read the resource group where the module created the storage account
data "azurerm_resource_group" "exports_rg" {
  name = local.data_rg
}

# ✅ Abilita publicNetworkAccess sullo Storage creato dal modulo
resource "azapi_update_resource" "exports_enable_public" {
  resource_id = module.storage_idpay_exports.id
  type        = "Microsoft.Storage/storageAccounts@2023-05-01"

  body = {
    properties = {
      publicNetworkAccess = "Enabled"
    }
  }
}

# ✅ Regole di rete: Allow + bypass AzureServices (facilita ADF, ecc.)
resource "azurerm_storage_account_network_rules" "exports_rules" {
  storage_account_id = module.storage_idpay_exports.id
  default_action     = "Allow"
  bypass             = ["AzureServices"]

  depends_on = [azapi_update_resource.exports_enable_public]
}
# CSV export container (kept private – public access is granted by SAS)
resource "azurerm_storage_container" "idpay_export_products_container" {
  name                  = "export"
  storage_account_id    = module.storage_idpay_exports.id
  container_access_type = "private"
}

#############################################
# RBAC for ADF
#############################################

# Data plane: allow ADF MI to read/write blobs in the storage account
resource "azurerm_role_assignment" "adf_can_access_exports_storage" {
  scope                = module.storage_idpay_exports.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_data_factory.data_factory.identity[0].principal_id

  depends_on = [module.storage_idpay_exports]
}

# Management plane: allow ADF MI to call ListServiceSas on the storage account
# (included in the built-in "Storage Account Contributor" role)
resource "azurerm_role_assignment" "adf_can_list_service_sas" {
  scope                = module.storage_idpay_exports.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = data.azurerm_data_factory.data_factory.identity[0].principal_id

  depends_on = [module.storage_idpay_exports]
}
