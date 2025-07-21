module "storage_idpay_audit" {
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
  name   = replace("${local.project}-audit-sa", "-", "")
  domain = var.domain

  # Network
  private_dns_zone_blob_ids  = [data.azurerm_private_dns_zone.blob_storage.id]
  private_dns_zone_table_ids = [data.azurerm_private_dns_zone.storage_account_table.id]
  private_endpoint_subnet_id = module.private_endpoint_storage_snet.id

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
  for_each = local.idpay_audit_containers

  name                  = each.key
  container_access_type = each.value
  storage_account_id    = module.storage_idpay_audit.id
}

#
# Logs Analytics Workspace
#
resource "azurerm_log_analytics_linked_storage_account" "idpay_audit_analytics_linked_storage" {
  data_source_type      = "CustomLogs"
  resource_group_name   = data.azurerm_log_analytics_workspace.core_log_analytics.resource_group_name
  workspace_resource_id = data.azurerm_log_analytics_workspace.core_log_analytics.id
  storage_account_ids   = [module.storage_idpay_audit.id]

  depends_on = [
    module.storage_idpay_audit
  ]
}

resource "azapi_resource" "idpay_audit_log_table" {
  type      = "Microsoft.OperationalInsights/workspaces/tables@2022-10-01"
  name      = "IdPayAuditLog_CL"
  parent_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

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
  resource_group_name     = data.azurerm_log_analytics_workspace.core_log_analytics.resource_group_name
  workspace_resource_id   = data.azurerm_log_analytics_workspace.core_log_analytics.id
  destination_resource_id = module.storage_idpay_audit.id
  table_names             = ["IdPayAuditLog_CL"]
  enabled                 = true

  depends_on = [
    module.storage_idpay_audit,
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
    account_name = module.storage_idpay_audit.name
  }

  provisioner "local-exec" {
    when    = create
    command = <<EOC
      az storage account blob-service-properties update \
        --account-name ${self.triggers.account_name} \
        --enable-restore-policy false \
      && \
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
    module.storage_idpay_audit,
    azurerm_log_analytics_data_export_rule.idpay_audit_analytics_export_rule,
    azurerm_storage_container.idpay_audit_container
  ]
}
