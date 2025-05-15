#
# Storage for Audit Logs Data
#
module "idpay_audit_storage" {
  source = "./.terraform/modules/__v4__/storage_account"

  name                = replace("${local.project}-audit-sa", "-", "")
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  location            = var.location
  account_kind        = "StorageV2"
  account_tier        = "Standard"

  access_tier                     = "Hot"
  account_replication_type        = var.storage_account_settings.replication_type
  blob_versioning_enabled         = var.storage_account_settings.enable_versioning
  advanced_threat_protection      = var.storage_account_settings.advanced_threat_protection_enabled
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false

  blob_delete_retention_days = var.storage_account_settings.delete_retention_days

  private_endpoint_enabled   = true
  private_dns_zone_blob_ids  = [data.azurerm_private_dns_zone.storage_account_blob.id]
  private_dns_zone_table_ids = [data.azurerm_private_dns_zone.storage_account_table.id]
  subnet_id                  = module.idpay_storage_snet.id

  tags = var.tags
}

#
# Containers
#
locals {
  idpay_audit_containers = {
    am-idpayauditlog-cl = "private"
  }
}

resource "azurerm_storage_container" "idpay_audit_container" {
  for_each              = local.idpay_audit_containers
  name                  = each.key
  container_access_type = each.value
  storage_account_id    = module.idpay_audit_storage.id
}

#
# Logs Analytics Workspace
#
resource "azurerm_log_analytics_linked_storage_account" "idpay_audit_analytics_linked_storage" {
  data_source_type      = "CustomLogs"
  resource_group_name   = data.azurerm_log_analytics_workspace.log_analytics.resource_group_name
  workspace_resource_id = data.azurerm_log_analytics_workspace.log_analytics.id
  storage_account_ids   = [module.idpay_audit_storage.id]
  depends_on            = [module.idpay_audit_storage]
}

resource "azapi_resource" "idpay_audit_log_table" {
  type      = "Microsoft.OperationalInsights/workspaces/tables@2022-10-01"
  name      = "IdPayAuditLog_CL"
  parent_id = data.azurerm_log_analytics_workspace.log_analytics.id

  body = {
    properties = {
      schema = {
        name = "IdPayAuditLog_CL"
        columns = [
          {
            name = "TimeGenerated"
            type = "datetime"
          },
          {
            name = "Log"
            type = "string"
          }
        ]
      }
    }
  }
}

resource "azurerm_log_analytics_data_export_rule" "idpay_audit_analytics_export_rule" {
  name                    = "${local.project}-audit-export-rule"
  resource_group_name     = data.azurerm_log_analytics_workspace.log_analytics.resource_group_name
  workspace_resource_id   = data.azurerm_log_analytics_workspace.log_analytics.id
  destination_resource_id = module.idpay_audit_storage.id
  table_names             = ["IdPayAuditLog_CL"]
  enabled                 = true

  depends_on = [
    module.idpay_audit_storage,
    azurerm_log_analytics_linked_storage_account.idpay_audit_analytics_linked_storage,
    azapi_resource.idpay_audit_log_table
  ]
}

#
# ⚖️ Legal Hold
#
resource "null_resource" "idpay_audit_legal_hold_configuration" {
  count = var.env != "dev" ? 1 : 0

  triggers = {
    account_name = module.idpay_audit_storage.name
  }

  provisioner "local-exec" {
    when    = create
    command = <<EOC
      az storage container legal-hold set \
        --account-name ${self.triggers.account_name} \
        --container-name am-idpayauditlog-cl \
        --tags idpayauditlog \
        --allow-protected-append-writes-all true
    EOC
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOD
      az storage container legal-hold clear \
        --account-name ${self.triggers.account_name} \
        --container-name am-idpayauditlog-cl \
        --tags idpayauditlog
    EOD
  }

  depends_on = [
    module.idpay_audit_storage,
    azurerm_log_analytics_data_export_rule.idpay_audit_analytics_export_rule,
    azurerm_storage_container.idpay_audit_container
  ]
}
