# =========================================
# Resource group per alert PARI
# =========================================
resource "azurerm_resource_group" "rg_pari_alerts" {
  count    = contains(["p", "u"], var.env_short) ? 1 : 0
  name     = "${local.project}-pari-alerts-rg"
  location = var.location
  tags     = module.tag_config.tags
}

# =============================================================
# Portal Consent – post (5xx, 401, 429 errors over 5 minutes)
# =============================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "portal_consent_save_5m_rules" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "portal-consent-save-5xx-401-429-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "Alert on POST /idpay-itn/register/consent errors (5xx > 5/5m; 401/429 > 5/5m)"
  severity    = 1
  enabled     = true

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name == "POST /idpay-itn/register/consent"
| where ResultCode startswith "5" or ResultCode in ("401", "429")
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 5
  }

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI] Portal Consent – save API alert (5xx/401/429)"
    custom_webhook_payload = "{}"
  }
}

# =============================================================
# Portal Consent – post (400 errors over 10 minutes)
# =============================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "portal_consent_save_10m_rule" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "portal-consent-save-400-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "Alert on POST /idpay-itn/register/consent errors (400 > 50/10m)"
  severity    = 1
  enabled     = true

  frequency   = 10
  time_window = 10

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name == "POST /idpay-itn/register/consent"
| where ResultCode == "400"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 50
  }

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI] Portal Consent – save API alert (400)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================================
# Portal Consent – get (5xx, 401, 429 errors over 5 minutes)
# =======================================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_portal_consent_get_5m_rules_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-portal-consent-get-5xx-401-429-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "Alert on GET /idpay-itn/register/consent errors (5xx > 5/5m; 401/429 > 5/5m)"
  severity    = 1
  enabled     = true

  frequency   = 5
  time_window = 5

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppRequests
| where Name == "GET /idpay-itn/register/consent"
| where ResultCode startswith "5" or ResultCode in ("401", "429")
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 5
  }

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI] Portal Consent GET /consent alert (5xx/401/429)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================================
# Portal Consent – get (400 errors over 10 minutes)
# =======================================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_portal_consent_get_10m_rule_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-portal-consent-get-400-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "Alert on GET /idpay-itn/register/consent errors (400 > 50/10m)"
  severity    = 1
  enabled     = true

  frequency   = 10
  time_window = 10

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppRequests
| where Name == "GET /idpay-itn/register/consent"
| where ResultCode == "400"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 50
  }

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI] Portal Consent GET /consent alert (400)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================================
# Product files – upload (5xx, 401, 429 errors over 5 minutes)
# =======================================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_product_files_upload_5m_rules_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-product-files-upload-5xx-401-429-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "Product files upload API: 5xx/401/429 error threshold exceeded (> 5/5m)"
  enabled     = true
  severity    = 2

  frequency   = 5
  time_window = 5

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppRequests
| where Name == "POST /idpay-itn/register/product-files"
| where ResultCode startswith "5" or ResultCode in ("401", "429")
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 5
  }

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI] Product files – upload API alert (5xx/401/429)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================================
# Product files – upload (400 errors over 10 minutes)
# =======================================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_product_files_upload_10m_rule_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-product-files-upload-400-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "Product files upload API: 400 error threshold exceeded (> 50/10m)"
  enabled     = true
  severity    = 2

  frequency   = 10
  time_window = 10

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppRequests
| where Name == "POST /idpay-itn/register/product-files"
| where ResultCode == "400"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 50
  }

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI] Product files – upload API alert (400)"
    custom_webhook_payload = "{}"
  }
}

# =========================================
# Product files – verify
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_product_files_verify_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-product-files-verify-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "Product files verify API: error threshold exceeded (5xx > 3/5m)"
  enabled     = true
  severity    = 2
  frequency   = 5
  time_window = 5

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppRequests
| where Name == "POST /idpay-itn/register/product-files/verify"
| where ResultCode startswith "5"
QUERY

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI] Product files verify alert"
    custom_webhook_payload = "{}"
  }

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 3
  }
}

# =========================================
# Products – update status
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_products_update_status_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-products-update-status-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "Products update status API: error threshold exceeded (5xx > 3/5m per endpoint)"
  enabled     = true
  severity    = 3
  frequency   = 5
  time_window = 5

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppRequests
| where Name in (
    "POST /idpay-itn/register/products/update-status/approved",
    "POST /idpay-itn/register/products/update-status/wait-approved",
    "POST /idpay-itn/register/products/update-status/supervised",
    "POST /idpay-itn/register/products/update-status/rejected",
    "POST /idpay-itn/register/products/update-status/restored"
)
| where ResultCode startswith "5"
QUERY

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI] Products update status alert"
    custom_webhook_payload = "{}"
  }

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 3
  }
}

# =========================================
# GET products - 5xx Error Count
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_get_products_5xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-get-products-5xx-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "GET /products API: 5xx error count exceeded (> 5 in 5m)"
  enabled     = true
  severity    = 0
  frequency   = 5
  time_window = 5

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppRequests
| where Name == "GET /idpay-itn/register/products"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 5
  }

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][CRITICAL] GET /products alert: High 5xx errors"
    custom_webhook_payload = "{}"
  }
}

# =========================================
# GET products - 400 Error Count
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_get_products_400_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-get-products-400-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "GET /products API: 400 error count exceeded (> 50 in 10m)"
  enabled     = true
  severity    = 0
  frequency   = 5
  time_window = 10

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppRequests
| where Name == "GET /idpay-itn/register/products"
| where ResultCode == "400"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 50
  }

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][CRITICAL] GET /products alert: High 400 errors"
    custom_webhook_payload = "{}"
  }
}

# =========================================
# GET products - Availability
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_get_products_availability_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-get-products-availability-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "GET /products API: Availability dropped below 99% in the last 10 minutes"
  enabled     = true
  severity    = 0
  frequency   = 5
  time_window = 10

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppRequests
| where Name == "GET /idpay-itn/register/products"
| summarize TotalRequests = count(), SuccessfulRequests = countif(Success == true)
| extend Availability = (todouble(SuccessfulRequests) / todouble(TotalRequests)) * 100
| where Availability < 99
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 1
  }

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][CRITICAL] GET /products alert: Availability is below 99%"
    custom_webhook_payload = "{}"
  }
}

# =======================================================================
# User Permissions - 5xx, 401, 429 errors over 5 minutes
# =======================================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_user_permissions_5m_rules_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-user-permissions-5m-rules-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "User Permissions API: 5xx > 5/5m; 401/429 > 5/5m"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppRequests
| where Name == "GET /idpay-itn/register/permissions"
| where ResultCode startswith "5" or ResultCode in ("401", "429")
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 5
  }

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][HIGH] User Permissions alert (5xx or 401/429)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================================
# User Permissions - 400 errors over 10 minutes
# =======================================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_user_permissions_10m_rule_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-user-permissions-400-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "User Permissions API: 400 > 50/10m"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 10

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppRequests
| where Name == "GET /idpay-itn/register/permissions"
| where ResultCode == "400"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 50
  }

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][HIGH] User Permissions alert (400)"
    custom_webhook_payload = "{}"
  }
}

# =========================================
# Product files – list
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_product_files_list_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-product-files-list-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "Product files list API: 5xx error count exceeded (> 5 in 5m)"
  enabled     = true
  severity    = 2

  frequency   = 5
  time_window = 5

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppRequests
| where Name == "GET /idpay-itn/register/product-files"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 5
  }

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI] Product files – list API alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =========================================
# Error report download
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_error_report_download_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-error-report-download-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "Error report download API: 5xx error count exceeded (> 5 in 5m)"
  enabled     = true
  severity    = 3

  frequency   = 5
  time_window = 5

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppRequests
| where Name == "GET /idpay-itn/register/product-files/*/report"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 5
  }

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI] Error report download API alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =========================================
# Batch list
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_batch_list_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-batch-list-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "Batch list API: 5xx error count exceeded (> 5 in 5m)"
  enabled     = true
  severity    = 3

  frequency   = 5
  time_window = 5

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppRequests
| where Name == "GET /idpay-itn/register/product-files/batch-list"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 5
  }

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI] Batch list API alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =========================================
# Institution by ID
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_institution_by_id_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-institution-by-id-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "Institution by ID API: 5xx error count exceeded (> 5 in 5m)"
  enabled     = true
  severity    = 3

  frequency   = 5
  time_window = 5

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppRequests
| where Name == "GET /idpay-itn/register/institutions/*"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 5
  }

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI] Institution by ID API alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =========================================
# Institutions list
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_institutions_list_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-institutions-list-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "Institutions list API: 5xx error count exceeded (> 5 in 5m)"
  enabled     = true
  severity    = 3

  frequency   = 5
  time_window = 5

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppRequests
| where Name == "GET /idpay-itn/register/institutions"
| where ResultCode startswith "5"
QUERY

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI] Institutions list API alert (5xx)"
    custom_webhook_payload = "{}"
  }

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 5
  }
}

# =======================================================
# Kafka Consumer - Absent Consumer Alert (5 min)
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_kafka_consumer_absent_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-kafka-consumer-absent-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "Kafka consumer 'idpay-checkiban-eval-consumer-group' has not sent any logs for the last 5 minutes."
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppTraces
| where TimeGenerated > ago(5m)
| where Message has "groupId=idpay-asset-register-consumer-group"
QUERY

  trigger {
    operator  = "Equal"
    threshold = 0
  }

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][HIGH] Kafka Consumer Absent: idpay-checkiban-eval-consumer-group"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# Kafka Consumer - Average Lag Alert (10 min)
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_kafka_consumer_avg_lag_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-kafka-consumer-avg-lag-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "Kafka consumer average lag is greater than 15 over the last 10 minutes. Based on the 'kafka_consumer_fetch_manager_records_lag_max' metric."
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 10

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppMetrics
| where TimeGenerated > ago(10m)
| where Name == "kafka_consumer_fetch_manager_records_lag_max"
| where Properties has "idpay-asset-register-consumer-group"
| summarize AvgLag = avg(Value)
| where AvgLag > 15
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 1
  }

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][HIGH] Kafka Consumer Lag Alert"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# Internal dependency – E-mail service
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_email_dependency_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-email-dependency-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "Internal email microservice: error count exceeded threshold (> 10 in 5m)"
  enabled     = true
  severity    = 2

  frequency   = 5
  time_window = 5

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppDependencies
| where TimeGenerated > ago(5m)
| where Target == "idpay-notification-email-microservice-chart:8080"
| where Success == false
QUERY

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI] Internal Email microservice dependency alert"
    custom_webhook_payload = "{}"
  }

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 10
  }
}

# =========================================
# External dependency  – EPREL
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_eprel_dependency_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-eprel-dependency-alert"
  resource_group_name = azurerm_resource_group.rg_pari_alerts[0].name
  location            = var.location

  description = "EPREL dependency: error count exceeded threshold (> 10 in 5m)"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics.id

  query = <<QUERY
AppDependencies
| where TimeGenerated > ago(5m)
| where Target == "eprel.ec.europa.eu"
| where Success == false
QUERY

  action {
    action_group           = [data.azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][HIGH] EPREL external dependency alert"
    custom_webhook_payload = "{}"
  }

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 10
  }
}
