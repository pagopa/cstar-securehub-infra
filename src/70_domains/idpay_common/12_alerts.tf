# =============================================================
# Alert API EIE
# =============================================================

# =============================================================
# Portal Consent – post (5xx, 401, 429 errors over 5 minutes)
# =============================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "portal_consent_save_5m_rules" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "portal-consent-save-5xx-401-429-alert"
  resource_group_name = local.monitor_rg
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
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][HIGH] Portal Consent – save API alert (5xx/401/429)"
    custom_webhook_payload = "{}"
  }
}

# =============================================================
# Portal Consent – post (400 errors over 10 minutes)
# =============================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "portal_consent_save_10m_rule" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "portal-consent-save-400-alert"
  resource_group_name = local.monitor_rg
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
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][HIGH] Portal Consent – save API alert (400)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================================
# Portal Consent – get (5xx, 401, 429 errors over 5 minutes)
# =======================================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_portal_consent_get_5m_rules_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-portal-consent-get-5xx-401-429-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "Alert on GET /idpay-itn/register/consent errors (5xx > 5/5m; 401/429 > 5/5m)"
  severity    = 1
  enabled     = true

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

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
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][HIGH] Portal Consent GET /consent alert (5xx/401/429)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================================
# Portal Consent – get (400 errors over 10 minutes)
# =======================================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_portal_consent_get_10m_rule_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-portal-consent-get-400-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "Alert on GET /idpay-itn/register/consent errors (400 > 50/10m)"
  severity    = 1
  enabled     = true

  frequency   = 10
  time_window = 10

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

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
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][HIGH] Portal Consent GET /consent alert (400)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================================
# Product files – upload (5xx, 401, 429 errors over 5 minutes)
# =======================================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_product_files_upload_5m_rules_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-product-files-upload-5xx-401-429-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "Product files upload API: 5xx/401/429 error threshold exceeded (> 5/5m)"
  enabled     = true
  severity    = 2

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

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
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][MEDIUM] Product files – upload API alert (5xx/401/429)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================================
# Product files – upload (400 errors over 10 minutes)
# =======================================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_product_files_upload_10m_rule_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-product-files-upload-400-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "Product files upload API: 400 error threshold exceeded (> 50/10m)"
  enabled     = true
  severity    = 2

  frequency   = 10
  time_window = 10

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

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
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][MEDIUM] Product files – upload API alert (400)"
    custom_webhook_payload = "{}"
  }
}

# =========================================
# Product files – verify
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_product_files_verify_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-product-files-verify-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "Product files verify API: error threshold exceeded (5xx > 3/5m)"
  enabled     = true
  severity    = 2
  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name == "POST /idpay-itn/register/product-files/verify"
| where ResultCode startswith "5"
QUERY

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][MEDIUM] Product files verify alert"
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
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "Products update status API: error threshold exceeded (5xx > 3/5m per endpoint)"
  enabled     = true
  severity    = 3
  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

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
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][LOW] Products update status alert"
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
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "GET /products API: 5xx error count exceeded (> 5 in 5m)"
  enabled     = true
  severity    = 0
  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

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
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][CRITICAL] GET /products alert: High 5xx errors"
    custom_webhook_payload = "{}"
  }
}

# =========================================
# GET products - 400 Error Count
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_get_products_400_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-get-products-400-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "GET /products API: 400 error count exceeded (> 50 in 10m)"
  enabled     = true
  severity    = 0
  frequency   = 5
  time_window = 10

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

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
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][CRITICAL] GET /products alert: High 400 errors"
    custom_webhook_payload = "{}"
  }
}

# =========================================
# GET products - Availability
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_get_products_availability_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-get-products-availability-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "GET /products API: Availability dropped below 99% in the last 10 minutes"
  enabled     = true
  severity    = 0
  frequency   = 5
  time_window = 10

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

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
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][CRITICAL] GET /products alert: Availability is below 99%"
    custom_webhook_payload = "{}"
  }
}

# =======================================================================
# User Permissions - 5xx, 401, 429 errors over 5 minutes
# =======================================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_user_permissions_5m_rules_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-user-permissions-5m-rules-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "User Permissions API: 5xx > 5/5m; 401/429 > 5/5m"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

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
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][HIGH] User Permissions alert (5xx or 401/429)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================================
# User Permissions - 400 errors over 10 minutes
# =======================================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_user_permissions_10m_rule_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-user-permissions-400-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "User Permissions API: 400 > 50/10m"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 10

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

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
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][HIGH] User Permissions alert (400)"
    custom_webhook_payload = "{}"
  }
}

# =========================================
# Product files – list
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_product_files_list_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-product-files-list-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "Product files list API: 5xx error count exceeded (> 5 in 5m)"
  enabled     = true
  severity    = 2

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

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
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][MEDIUM] Product files – list API alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =========================================
# Error report download
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_error_report_download_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-error-report-download-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "Error report download API: 5xx error count exceeded (> 5 in 5m)"
  enabled     = true
  severity    = 3

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^GET /idpay-itn/register/product-files/[^/]+/report$"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 5
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][LOW] Error report download API alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =========================================
# Batch list
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_batch_list_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-batch-list-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "Batch list API: 5xx error count exceeded (> 5 in 5m)"
  enabled     = true
  severity    = 3

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

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
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][LOW] Batch list API alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =========================================
# Institution by ID
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_institution_by_id_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-institution-by-id-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "Institution by ID API: 5xx error count exceeded (> 5 in 5m)"
  enabled     = true
  severity    = 3

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^GET /idpay-itn/register/institutions/[^/]+$"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 5
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][LOW] Institution by ID API alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =========================================
# Institutions list
# =========================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_institutions_list_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-institutions-list-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "Institutions list API: 5xx error count exceeded (> 5 in 5m)"
  enabled     = true
  severity    = 3

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name == "GET /idpay-itn/register/institutions"
| where ResultCode startswith "5"
QUERY

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][LOW] Institutions list API alert (5xx)"
    custom_webhook_payload = "{}"
  }

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 5
  }
}

# =======================================================
# Internal dependency – E-mail service
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pari_email_dependency_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pari-email-dependency-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "Internal email microservice: error count exceeded threshold (> 10 in 5m)"
  enabled     = true
  severity    = 2

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppDependencies
| where TimeGenerated > ago(5m)
| where Target == "idpay-notification-email-microservice-chart:8080"
| where Success == false
QUERY

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][MEDIUM] Internal Email microservice dependency alert"
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
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "EPREL dependency: error count exceeded threshold (> 10 in 5m)"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppDependencies
| where TimeGenerated > ago(5m)
| where Target == "eprel.ec.europa.eu"
| where Success == false
QUERY

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][EIE][HIGH] EPREL external dependency alert"
    custom_webhook_payload = "{}"
  }

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 10
  }
}

# =============================================================
# Alert API ESE
# =============================================================

# =======================================================
# Capture the transaction - 5xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "capture_transaction_5xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "capture-transaction-5xx-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API Capture Transaction: 5xx error count exceeded (> 2 in 5m)"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^PUT /idpay-itn/merchant-op/transactions/bar-code/[^/]+/capture$"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 2
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][HIGH] Capture Transaction API Alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# Capture the transaction - 401/404/429 Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "capture_transaction_4xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "capture-transaction-4xx-auth-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API Capture Transaction: 401/404/429 error count exceeded (> 20 in 5m)"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^PUT /idpay-itn/merchant-op/transactions/bar-code/[^/]+/capture$"
| where ResultCode in ("401", "404", "429")
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 20
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][HIGH] Capture Transaction API Alert (4xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# Preview Payment - 5xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "preview_payment_5xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "preview-payment-5xx-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API Preview Payment: 5xx error count exceeded (> 2 in 5m)"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^PUT /idpay-itn/merchant-op/transactions/bar-code/[^/]+/preview$"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 2
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][HIGH] Preview Payment API Alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# Preview Payment - 401/429 Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "preview_payment_4xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "preview-payment-4xx-auth-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API Preview Payment: 401/429 error count exceeded (> 20 in 5m)"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^PUT /idpay-itn/merchant-op/transactions/bar-code/[^/]+/preview$"
| where ResultCode in ("401", "429")
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 20
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][HIGH] Preview Payment API Alert (4xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# Authorize payment - 5xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "authorize_payment_5xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "authorize-payment-5xx-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API Authorize Payment: 5xx error count exceeded (> 2 in 5m)"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^PUT /idpay-itn/merchant-op/transactions/bar-code/[^/]+/authorize$"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 2
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][HIGH] Authorize Payment API Alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# Authorize payment - 4xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "authorize_payment_4xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "authorize-payment-4xx-auth-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API Authorize Payment: 401/403/404/429 error count exceeded (> 20 in 5m)"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^PUT /idpay-itn/merchant-op/transactions/bar-code/[^/]+/authorize$"
| where ResultCode in ("401", "403", "404", "429")
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 20
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][HIGH] Authorize Payment API Alert (4xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# Download invoice file - 5xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "download_invoice_5xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "download-invoice-file-5xx-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API Download Invoice File: 5xx error count exceeded (> 2 in 5m)"
  enabled     = true
  severity    = 3

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^GET /idpay-itn/merchant/portal/[^/]+/transactions/[^/]+/download$"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 2
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][LOW] Download Invoice File API Alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# Download invoice file - 4xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "download_invoice_4xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "download-invoice-file-4xx-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API Download Invoice File: 400/401/429 error count exceeded (> 1 in 5m)"
  enabled     = true
  severity    = 3

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^GET /idpay-itn/merchant/portal/[^/]+/transactions/[^/]+/download$"
| where ResultCode in ("400", "401", "429")
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 1
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][LOW] Download Invoice File API Alert (4xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# POS In Progress Transactions List - 5xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pos_transactions_list_5xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pos-transactions-inprogress-list-5xx-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API POS In Progress Transactions List: 5xx error count exceeded (> 2 in 5m)"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^GET /idpay-itn/merchant-op/initiatives/[^/]+/point-of-sales/[^/]+/transactions$"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 2
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][HIGH] POS In Progress Transactions List API Alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# POS In Progress Transactions List - 4xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pos_transactions_list_4xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pos-transactions-inprogress-list-4xx-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API POS In Progress Transactions List: 401/404/429 error count exceeded (> 5 in 5m)"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^GET /idpay-itn/merchant-op/initiatives/[^/]+/point-of-sales/[^/]+/transactions$"
| where ResultCode in ("401", "404", "429")
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 5
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][HIGH] POS In Progress Transactions List API Alert (4xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# POS Processed Transactions List - 5xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pos_transactions_processed_5xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pos-transactions-processed-5xx-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API POS Processed Transactions List: 5xx error count exceeded (> 2 in 5m)"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^GET /idpay-itn/merchant-op/initiatives/[^/]+/point-of-sales/[^/]+/transactions/processed$"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 2
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][HIGH] POS Processed Transactions List API Alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# POS Processed Transactions List - 4xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "pos_transactions_processed_4xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "pos-transactions-processed-4xx-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API POS Processed Transactions List: 401/404/429 error count exceeded (> 5 in 5m)"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^GET /idpay-itn/merchant-op/initiatives/[^/]+/point-of-sales/[^/]+/transactions/processed$"
| where ResultCode in ("401", "404", "429")
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 5
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][HIGH] POS Processed Transactions List API Alert (4xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# Delete Transaction - 5xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "delete_transaction_5xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "delete-transaction-5xx-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API Delete Transaction: 5xx error count exceeded (> 2 in 5m)"
  enabled     = true
  severity    = 3

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^DELETE /idpay-itn/merchant-op/transactions/[^/]+$"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 2
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][LOW] Delete Transaction API Alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# Delete Transaction - 4xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "delete_transaction_4xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "delete-transaction-4xx-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API Delete Transaction: 401/403/404/429 error count exceeded (> 5 in 5m)"
  enabled     = true
  severity    = 3

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^DELETE /idpay-itn/merchant-op/transactions/[^/]+$"
| where ResultCode in ("401", "403", "404", "429")
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 5
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][LOW] Delete Transaction API Alert (4xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# Reversal Transaction - 5xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "reversal_transaction_5xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "reversal-transaction-5xx-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API Reversal Transaction: 5xx error count exceeded (> 2 in 5m)"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^POST /idpay-itn/merchant-op/transactions/[^/]+/reversal$"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 2
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][HIGH] Reversal Transaction API Alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# Reward Transaction - 5xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "reward_transaction_5xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "reward-transaction-5xx-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API Reward Transaction: 5xx error count exceeded (> 2 in 5m)"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^POST /idpay-itn/merchant-op/transactions/[^/]+/reward$"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 2
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][HIGH] Reward Transaction API Alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# Retrieve a point of sale - 5xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "retrieve_pos_5xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "retrieve-point-of-sale-5xx-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API Retrieve a point of sale: 5xx error count exceeded (> 2 in 5m)"
  enabled     = true
  severity    = 3

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^GET /idpay-itn/merchant/portal/[^/]+/point-of-sales/[^/]+$"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 2
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][LOW] Retrieve a point of sale API Alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# Retrieve a point of sale - 4xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "retrieve_pos_4xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "retrieve-point-of-sale-4xx-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API Retrieve a point of sale: 401/404/429 error count exceeded (> 3 in 5m)"
  enabled     = true
  severity    = 3

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name matches regex @"^GET /idpay-itn/merchant/portal/[^/]+/point-of-sales/[^/]+$"
| where ResultCode in ("401", "404", "429")
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 3
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][LOW] Retrieve a point of sale API Alert (4xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# Products List - 5xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "products_list_5xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "products-list-5xx-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API Products List: 5xx error count exceeded (> 2 in 5m)"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name == "GET /idpay-itn/merchant-op/products"
| where ResultCode startswith "5"
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 2
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][HIGH] Products List API Alert (5xx)"
    custom_webhook_payload = "{}"
  }
}

# =======================================================
# Products List - 4xx Error Count
# =======================================================
resource "azurerm_monitor_scheduled_query_rules_alert" "products_list_4xx_alert" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = "products-list-4xx-alert"
  resource_group_name = local.monitor_rg
  location            = var.location

  description = "API Products List: 401/404/429 error count exceeded (> 15 in 5m)"
  enabled     = true
  severity    = 1

  frequency   = 5
  time_window = 5

  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  query = <<QUERY
AppRequests
| where Name == "GET /idpay-itn/merchant-op/products"
| where ResultCode in ("401", "404", "429")
QUERY

  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 15
  }

  action {
    action_group           = [azurerm_monitor_action_group.email[0].id]
    email_subject          = "[PARI][ESE][HIGH] Products List API Alert (4xx)"
    custom_webhook_payload = "{}"
  }
}
