data "azurerm_resources" "aks_vmss" {
  resource_group_name = data.azurerm_kubernetes_cluster.aks.node_resource_group
  type                = "Microsoft.Compute/virtualMachineScaleSets"
}

locals {
  aks_vmss_idpay_ids = {
    for pool in data.azurerm_resources.aks_vmss.resources :
    lower(pool.name) => pool.id
    if length(regexall("idpay", lower(pool.name))) > 0
  }

  audit_dce_name      = "${local.project}-audit-dce"
  audit_dcr_name      = "${local.project}-audit-dcr"
  audit_dcra_name     = "${local.project}-audit-dcra"
  subscription_id     = data.azurerm_subscription.current.subscription_id
  resource_group_name = data.azurerm_resource_group.idpay_monitoring_rg.name
}

resource "azurerm_monitor_data_collection_endpoint" "idpay_audit_dce" {
  name                          = local.audit_dce_name
  resource_group_name           = local.resource_group_name
  location                      = var.location
  public_network_access_enabled = true
  description                   = "audit dce"
  tags                          = module.tag_config.tags
}

resource "azurerm_monitor_data_collection_rule" "idpay_audit_dcr" {
  name                        = local.audit_dcr_name
  location                    = var.location
  resource_group_name         = local.resource_group_name
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.idpay_audit_dce.id
  description                 = "IDPay audit DCR"

  stream_declaration {
    stream_name = "Custom-IdPayAuditLog_CL"

    column {
      name = "TimeGenerated"
      type = "datetime"
    }

    column {
      name = "RawData"
      type = "string"
    }
  }

  data_sources {
    log_file {
      name          = "IdPayAuditLog_CL"
      streams       = ["Custom-IdPayAuditLog_CL"]
      file_patterns = ["/var/log/containers/*"]
      format        = "text"

      settings {
        text {
          record_start_timestamp_format = "ISO 8601"
        }
      }
    }
  }

  destinations {
    log_analytics {
      name                  = data.azurerm_log_analytics_workspace.core_log_analytics.name
      workspace_resource_id = data.azurerm_log_analytics_workspace.core_log_analytics.id
    }
  }

  data_flow {
    streams       = ["Custom-IdPayAuditLog_CL"]
    destinations  = [data.azurerm_log_analytics_workspace.core_log_analytics.name]
    transform_kql = <<-KQL
      source | extend Log=RawData | where Log contains "CEF:"
    KQL
    output_stream = "Custom-IdPayAuditLog_CL"
  }

  tags = module.tag_config.tags
}

resource "azurerm_monitor_data_collection_rule_association" "idpay_audit_dcra" {
  for_each                = local.aks_vmss_idpay_ids
  name                    = "${local.audit_dcra_name}-${each.key}"
  target_resource_id      = each.value
  data_collection_rule_id = azurerm_monitor_data_collection_rule.idpay_audit_dcr.id
  description             = "idpay_audit_dcra"

  depends_on = [azurerm_monitor_data_collection_rule.idpay_audit_dcr]
}

resource "azurerm_monitor_data_collection_rule_association" "idpay_audit_dce_association" {
  for_each                    = local.aks_vmss_idpay_ids
  target_resource_id          = each.value
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.idpay_audit_dce.id
  description                 = "idpay_audit_dce_association"

  depends_on = [azurerm_monitor_data_collection_endpoint.idpay_audit_dce]
}

output "aks_vmss_idpay_ids" {
  value = local.aks_vmss_idpay_ids
}
