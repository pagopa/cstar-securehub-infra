#
# Onboarding census (BND-2482)
# Private storage for the CSV of fiscal codes of citizens who already used the bonus,
# plus the per-run report and the rejected rows (dead-letter) produced by ADF.
# Files contain plain fiscal codes: no public access, deleted by lifecycle after N days.
#
module "storage_idpay_onboarding_census" {
  source = "./.terraform/modules/__v4__/IDH/storage_account"

  # General
  product_name        = var.prefix
  env                 = var.env
  location            = var.location
  resource_group_name = local.data_rg
  tags                = module.tag_config.tags

  # IDH Resources (basic = public network access disabled, private endpoint enabled)
  idh_resource_tier = "basic"

  # Storage Account Settings
  name   = replace("${local.project}-census-sa", "-", "")
  domain = var.domain

  # Network
  private_dns_zone_blob_ids  = [data.azurerm_private_dns_zone.blob_storage.id]
  private_endpoint_subnet_id = module.private_endpoint_storage_snet.id
}

#
# Containers
# Folders: input/ (CSV to process), report/ (run report), rejected/ (dead-letter rows)
#
resource "azurerm_storage_container" "idpay_onboarding_census_container" {
  name                  = "onboarding-census"
  storage_account_id    = module.storage_idpay_onboarding_census.id
  container_access_type = "private"
}

#
# Lifecycle: census files contain PII, keep them only for the configured retention
#
resource "azurerm_storage_management_policy" "idpay_onboarding_census_retention" {
  storage_account_id = module.storage_idpay_onboarding_census.id

  rule {
    name    = "delete-onboarding-census-files"
    enabled = true

    filters {
      blob_types   = ["blockBlob"]
      prefix_match = ["${azurerm_storage_container.idpay_onboarding_census_container.name}/"]
    }

    actions {
      base_blob {
        delete_after_days_since_creation_greater_than = var.onboarding_census_retention_days
      }
      version {
        delete_after_days_since_creation = var.onboarding_census_retention_days
      }
    }
  }
}

#
# Roles
#

# ADF MI -> read input CSV, write report and rejected rows
resource "azurerm_role_assignment" "adf_can_access_onboarding_census_storage" {
  scope                = module.storage_idpay_onboarding_census.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_data_factory.data_factory.identity[0].principal_id

  depends_on = [module.storage_idpay_onboarding_census]
}
