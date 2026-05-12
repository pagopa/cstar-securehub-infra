resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${local.project}-law"
  location            = var.location
  resource_group_name = local.monitor_rg
  tags                = module.tag_config.tags


  sku               = var.law_sku
  retention_in_days = var.law_retention_in_days
  daily_quota_gb    = var.law_daily_quota_gb


  lifecycle {
    ignore_changes = [
      sku
    ]
  }
}

resource "azurerm_role_assignment" "platform_dex_to_mdc_law" {
  scope                = azurerm_log_analytics_workspace.log_analytics_workspace.id
  role_definition_name = "Log Analytics Data Reader"
  principal_id         = data.azurerm_kusto_cluster.kusto_cluster.identity[0].principal_id
}

resource "azurerm_role_assignment" "platform_adf_to_mdc_law" {
  scope                = azurerm_log_analytics_workspace.log_analytics_workspace.id
  role_definition_name = "Log Analytics Data Reader"
  principal_id         = data.azurerm_data_factory.data_factory.identity[0].principal_id
}

### 🔍 Application insights
resource "azurerm_application_insights" "application_insights" {
  name                 = "${local.project}-appinsights"
  location             = var.location
  resource_group_name  = local.monitor_rg
  daily_data_cap_in_gb = var.law_daily_quota_gb
  tags                 = module.tag_config.tags

  application_type = "other"

  workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

}


### 🔍 Logger APIM
resource "azurerm_api_management_logger" "apim_logger" {
  name                = "${local.project}-apim-logger"
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_api_management.apim.resource_group_name
  resource_id         = azurerm_application_insights.application_insights.id

  application_insights {
    instrumentation_key = azurerm_application_insights.application_insights.instrumentation_key
  }
}

### Action Group
# resource "azurerm_monitor_action_group" "email" {
#   count               = contains(["p", "u"], var.env_short) ? 1 : 0
#   name                = local.monitor_action_group_email_name
#   resource_group_name = local.monitor_rg
#   short_name          = "pari-email"
#   enabled             = true
#
#   dynamic "email_receiver" {
#     for_each = var.env_short == "u" ? [1] : []
#     content {
#       name                    = "pari-alerts-email_-EmailAction-"
#       email_address           = "pari.alert.test@gmail.com"
#       use_common_alert_schema = false
#     }
#   }
# }

resource "azurerm_monitor_action_group" "opsgenie" { #
  count = var.env_short == "p" ? 1 : 0

  name                = "${title(var.domain)}Opsgenie"
  resource_group_name = local.monitor_rg
  short_name          = "${title(var.domain)}Opsgenie" # -> Max 12 char

  webhook_receiver {
    name                    = "${title(var.domain)}OpsgenieWebhook"
    service_uri             = "https://api.opsgenie.com/v1/json/azure?apiKey=${module.secrets.values["opsgenie-api-key"].value}"
    use_common_alert_schema = true
  }

  tags = module.tag_config.tags
}
