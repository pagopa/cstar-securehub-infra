#
# Local Variables
#
locals {
  log_analytics_workspace_id   = data.azurerm_log_analytics_workspace.log_analytics.id
  log_analytics_workspace_name = data.azurerm_log_analytics_workspace.log_analytics.name
  audit_dce_name               = "${var.domain}${var.env_short}-audit-dce"
  audit_dcr_name               = "${var.domain}${var.env_short}-audit-dcr"
  audit_dcra_name              = "${var.domain}${var.env_short}-audit-dcra"
  subscription_id              = data.azurerm_subscription.current.subscription_id
  resource_group_name          = data.azurerm_application_insights.application_insights.resource_group_name
  audit_dce_id                 = "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Insights/dataCollectionEndpoints/${local.audit_dce_name}"
  audit_dcr_id                 = "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Insights/dataCollectionRules/${local.audit_dcr_name}"
  az_rest_api_dcr              = "https://management.azure.com/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Insights/dataCollectionRules/${local.audit_dcr_name}?api-version=2021-09-01-preview"
}

#
# Storage for Audit Logs Data
#
module "idpay_audit_storage" {
  source = "./.terraform/modules/__v4__/storage_account"

  name                            = replace("${var.domain}${var.env_short}-audit-storage", "-", "")
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = var.storage_account_settings.replication_type
  access_tier                     = "Hot"
  blob_versioning_enabled         = var.storage_account_settings.enable_versioning
  resource_group_name             = data.azurerm_log_analytics_workspace.log_analytics.resource_group_name
  location                        = var.location
  advanced_threat_protection      = var.storage_account_settings.advanced_threat_protection_enabled
  allow_nested_items_to_be_public = false

  blob_delete_retention_days    = var.storage_account_settings.delete_retention_days
  public_network_access_enabled = var.storage_account_settings.public_network_access_enabled

  private_endpoint_enabled  = var.storage_account_settings.private_endpoint_enabled
  private_dns_zone_blob_ids = [data.azurerm_private_dns_zone.storage_account.id]
  subnet_id                 = data.azurerm_subnet.private_endpoint_subnet.id

  tags = var.tags
}



# Set legal hold on container created by azure monitor with the data exporter (the name is fixed and definid by the exporter)
resource "null_resource" "idpay_audit_lh" {
  provisioner "local-exec" {
    command = <<EOC
      az storage container legal-hold set --account-name ${module.idpay_audit_storage.name} --container-name am-idpayauditlog-cl --tags idpayauditlog --allow-protected-append-writes-all true
      EOC
  }
  depends_on = [module.idpay_audit_storage, azurerm_log_analytics_data_export_rule.idpay_audit_analytics_export_rule]
}


resource "azurerm_log_analytics_linked_storage_account" "idpay_audit_analytics_linked_storage" {
  data_source_type      = "CustomLogs"
  resource_group_name   = data.azurerm_log_analytics_workspace.log_analytics.resource_group_name
  workspace_resource_id = data.azurerm_log_analytics_workspace.log_analytics.id
  storage_account_ids   = [module.idpay_audit_storage.id]
  depends_on            = [module.idpay_audit_storage]
}

resource "azurerm_log_analytics_data_export_rule" "idpay_audit_analytics_export_rule" {
  name                    = "${var.domain}${var.env_short}-audit-export-rule"
  resource_group_name     = data.azurerm_log_analytics_workspace.log_analytics.resource_group_name
  workspace_resource_id   = data.azurerm_log_analytics_workspace.log_analytics.id
  destination_resource_id = module.idpay_audit_storage.id
  table_names             = ["IdPayAuditLog_CL"]
  enabled                 = true
  depends_on              = [module.idpay_audit_storage, azurerm_log_analytics_linked_storage_account.idpay_audit_analytics_linked_storage]
}
