resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${local.project}-law"
  location            = var.location
  resource_group_name = local.monitor_rg_name
  sku                 = var.law_sku
  retention_in_days   = var.law_retention_in_days
  daily_quota_gb      = var.law_daily_quota_gb

  tags = module.tag_config.tags

  lifecycle {
    ignore_changes = [
      sku
    ]
  }
}

### 🔍 Application insights
resource "azurerm_application_insights" "application_insights" {
  name                = "${local.project}-appinsights"
  location            = var.location
  resource_group_name = local.monitor_rg_name
  application_type    = "other"
  workspace_id        = azurerm_log_analytics_workspace.log_analytics_workspace.id

  tags = module.tag_config.tags
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

# ------------------------------------------------------------------------------
# Storing Application Insights connection strings in the general key vault.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "core_application_insigths_connection_string" {
  name         = "core-application-insigths-connection-string"
  value        = azurerm_application_insights.application_insights.connection_string
  key_vault_id = data.azurerm_key_vault.domain_general_kv.id
  tags         = module.tag_config.tags
}

# ------------------------------------------------------------------------------
# Query pack.
# ------------------------------------------------------------------------------
resource "azurerm_log_analytics_query_pack" "mcshared" {
  name                = "${local.project}-pack"
  location            = var.location
  resource_group_name = local.monitor_rg_name
  tags                = module.tag_config.tags
}

# ------------------------------------------------------------------------------
# Query for stdout/stdin of auth microservice.
# ------------------------------------------------------------------------------
resource "azurerm_log_analytics_query_pack_query" "auth" {
  query_pack_id = azurerm_log_analytics_query_pack.mcshared.id
  display_name  = "*** mcshared -- auth -- last hour ***"
  body          = <<-EOT
    ContainerAppConsoleLogs_CL
    | where ContainerName_s == 'mil-auth'
    | where time_t > ago(60m)
    | sort by time_t asc
    | extend ParsedJSON = parse_json(Log_s)
    | project
        app_timestamp=ParsedJSON.timestamp,
        app_sequence=ParsedJSON.sequence,
        app_loggerClassName=ParsedJSON.loggerClassName,
        app_loggerName=ParsedJSON.loggerName,
        app_level=ParsedJSON.level,
        app_message=ParsedJSON.message,
        app_threadName=ParsedJSON.threadName,
        app_threadId=ParsedJSON.threadId,
        app_mdc=ParsedJSON.mdc,
        app_requestId=ParsedJSON.mdc.requestId,
        app_end2endTrxOperationId=ParsedJSON.mdc.traceId,
        app_ndc=ParsedJSON.ndc,
        app_hostName=ParsedJSON.hostName,
        app_processId=ParsedJSON.processId,
        app_exception=ParsedJSON.exception
  EOT
}
