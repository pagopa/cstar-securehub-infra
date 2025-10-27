#-----------------------------------------------------------------------------------
# Storage Accounts for SRTP Common
#-----------------------------------------------------------------------------------
module "srtp_storage_account" {
  source = "./.terraform/modules/__v4__/IDH/storage_account"

  # Storage Account Settings
  name   = replace("${local.project}-sa", "-", "")
  domain = var.domain

  # General
  product_name        = var.prefix
  env                 = var.env
  location            = var.location
  resource_group_name = local.data_rg_name
  tags                = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = var.env_short != "prod" ? "basic" : "backup30"

  # Network
  private_dns_zone_blob_ids  = [data.azurerm_private_dns_zone.blob_storage.id]
  private_endpoint_subnet_id = module.private_endpoint_storage_account_snet.id
}

resource "azurerm_storage_container" "srtp_container" {
  for_each = toset(["rtp-debtor-service-provider", "rtp-payees-registry"])

  storage_account_id    = module.srtp_storage_account.id
  name                  = each.key
  container_access_type = "private"
}

#-------------------------------------------------------------------------------
# File Share Storage Account
# ------------------------------------------------------------------------------
module "share_storage_account" {
  source = "./.terraform/modules/__v4__/IDH/storage_account"

  # Storage Account Settings
  name   = replace("${local.project}-share-sa", "-", "")
  domain = var.domain

  # General
  product_name        = var.prefix
  env                 = var.env
  location            = var.location
  resource_group_name = local.data_rg_name
  tags                = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = var.env_short != "p" ? "basic_public" : "backup7_public"

  # Network
  private_dns_zone_file_ids  = [data.azurerm_private_dns_zone.file_storage.id]
  private_endpoint_subnet_id = module.private_endpoint_storage_account_snet.id
}

resource "azurerm_storage_share" "rtp_jks_file_share" {
  storage_account_id = module.share_storage_account.id
  name               = "${local.project}-jks-file-share"
  quota              = 1
}

resource "azurerm_role_assignment" "aks_access_to_share_storage" {
  scope                = module.share_storage_account.id
  role_definition_name = "Storage File Data SMB Share Reader"
  principal_id         = data.azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

resource "kubernetes_secret" "azure_files_secret" {
  metadata {
    name      = "azure-files-secret"
    namespace = "srtp"
  }

  data = {
    azurestorageaccountname = module.share_storage_account.name
    azurestorageaccountkey  = module.share_storage_account.primary_access_key
  }

  type = "Opaque"
}


