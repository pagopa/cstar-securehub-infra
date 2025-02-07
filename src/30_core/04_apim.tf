resource "azurerm_resource_group" "rg_api" {
  name     = "${local.project}-api-rg"
  location = var.location

  tags = var.tags
}

#
# Api Management
#

module "apim" {
  source = "./.terraform/modules/__v3__/api_management"

  subnet_id               = data.azurerm_subnet.apim_snet.id
  location                = var.location
  name                    = "${local.project}-apim"
  resource_group_name     = azurerm_resource_group.rg_api.name
  publisher_name          = var.apim_publisher_name
  publisher_email         = data.azurerm_key_vault_secret.apim_publisher_email.value
  sku_name                = var.apim_sku
  virtual_network_type    = "Internal"
  public_ip_address_id    = data.azurerm_public_ip.apim_public_ip.id
  redis_connection_string = null
  redis_cache_id          = null

  # This enables the Username and Password Identity Provider
  sign_up_enabled = false

  lock_enable = false

  zones = var.zones

  application_insights = {
    enabled             = true
    instrumentation_key = azurerm_application_insights.application_insights.instrumentation_key
  }


  xml_content = templatefile("./api/base_policy.tpl", {
    portal-domain         = local.portal_domain
    management-api-domain = local.management_domain
    apim-name             = "${local.project}-apim"
  })

  # Enabled if sku_name = Premium_1
  autoscale = var.apim_autoscale

  alerts_enabled = var.apim_alerts_enabled

  action = [
    {
      action_group_id    = azurerm_monitor_action_group.slack.id
      webhook_properties = null
    },
    #    {
    #      action_group_id    = azurerm_monitor_action_group.email.id
    #      webhook_properties = null
    #    }
  ]

  # metrics docs
  # https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported#microsoftapimanagementservice
  metric_alerts = {
    capacity = {
      description   = "Apim used capacity is too high"
      frequency     = "PT5M"
      window_size   = "PT5M"
      severity      = 1
      auto_mitigate = true

      criteria = [{
        metric_namespace       = "Microsoft.ApiManagement/service"
        metric_name            = "Capacity"
        aggregation            = "Average"
        operator               = "GreaterThan"
        threshold              = 50
        skip_metric_validation = false
        dimension              = []
      }]
      dynamic_criteria = []
    }

    duration = {
      description   = "Apim abnormal response time"
      frequency     = "PT5M"
      window_size   = "PT5M"
      severity      = 2
      auto_mitigate = true

      criteria = []

      dynamic_criteria = [{
        metric_namespace         = "Microsoft.ApiManagement/service"
        metric_name              = "Duration"
        aggregation              = "Average"
        operator                 = "GreaterThan"
        alert_sensitivity        = "High"
        evaluation_total_count   = 2
        evaluation_failure_count = 2
        skip_metric_validation   = false
        ignore_data_before       = "2021-01-01T00:00:00Z" # sample data
        dimension                = []
      }]
    }

    requests_failed = {
      description   = "Apim abnormal failed requests"
      frequency     = "PT5M"
      window_size   = "PT5M"
      severity      = 2
      auto_mitigate = true

      criteria = []

      dynamic_criteria = [{
        metric_namespace         = "Microsoft.ApiManagement/service"
        metric_name              = "Requests"
        aggregation              = "Total"
        operator                 = "GreaterThan"
        alert_sensitivity        = "High"
        evaluation_total_count   = 2
        evaluation_failure_count = 2
        skip_metric_validation   = false
        ignore_data_before       = "2021-01-01T00:00:00Z" # sample data
        dimension = [{
          name     = "BackendResponseCode"
          operator = "Include"
          values   = ["5xx"]
        }]
      }]
    }
  }

  tags = var.tags

  depends_on = [
    azurerm_application_insights.application_insights
  ]
}

resource "azurerm_api_management_custom_domain" "api_custom_domain" {
  api_management_id = module.apim.id

  gateway {
    host_name = local.api_domain
    key_vault_id = replace(
      data.azurerm_key_vault_certificate.api_p4pa.secret_id,
      "/${data.azurerm_key_vault_certificate.api_p4pa.version}",
      ""
    )
  }

  developer_portal {
    host_name = local.portal_domain
    key_vault_id = replace(
      data.azurerm_key_vault_certificate.portal_p4pa.secret_id,
      "/${data.azurerm_key_vault_certificate.portal_p4pa.version}",
      ""
    )
  }

  management {
    host_name = local.management_domain
    key_vault_id = replace(
      data.azurerm_key_vault_certificate.management_p4pa.secret_id,
      "/${data.azurerm_key_vault_certificate.management_p4pa.version}",
      ""
    )
  }

}

## api management policy ##
resource "azurerm_key_vault_access_policy" "api_management_policy" {
  key_vault_id = local.kv_id_core
  tenant_id    = local.tenant_id
  object_id    = module.apim.principal_id

  key_permissions         = []
  secret_permissions      = ["Get", "List"]
  certificate_permissions = ["Get", "List"]
  storage_permissions     = []

  depends_on = [
    module.apim
  ]
}
