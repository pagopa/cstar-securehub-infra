# =============================================================
# Alert API EIE
# =============================================================

locals {
  alert_action_group = compact([
    try(data.azurerm_monitor_action_group.alerts_email[0].id, null),
    var.env_short == "p" ? try(data.azurerm_monitor_action_group.alerts_opsgenie[0].id, null) : null
  ])

  alert_defaults = {
    enabled        = true
    severity       = 1
    frequency      = 5
    time_window    = 5
    data_source_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  }

  alerts_register = {
    portal_consent_save_5m_rules = {
      name        = "portal-consent-save-5xx-401-429-alert"
      description = "Alert on POST /idpay-itn/register/consent errors (5xx > 5/5m; 401/429 > 5/5m)"
      query       = <<-QUERY
            AppRequests
            | where Name == "POST /idpay-itn/register/consent"
            | where ResultCode startswith "5" or ResultCode in ("401", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI] Portal Consent – save API alert (5xx/401/429)"
    }

    portal_consent_save_10m_rule = {
      name        = "portal-consent-save-400-alert"
      description = "Alert on POST /idpay-itn/register/consent errors (400 > 50/10m)"
      frequency   = 10
      time_window = 10
      query       = <<-QUERY
            AppRequests
            | where Name == "POST /idpay-itn/register/consent"
            | where ResultCode == "400"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 50
      }
      email_subject = "[PARI] Portal Consent – save API alert (400)"
    }

    pari_portal_consent_get_5m_rules_alert = {
      name        = "pari-portal-consent-get-5xx-401-429-alert"
      description = "Alert on GET /idpay-itn/register/consent errors (5xx > 5/5m; 401/429 > 5/5m)"
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/register/consent"
            | where ResultCode startswith "5" or ResultCode in ("401", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI] Portal Consent GET /consent alert (5xx/401/429)"
    }

    pari_portal_consent_get_10m_rule_alert = {
      name        = "pari-portal-consent-get-400-alert"
      description = "Alert on GET /idpay-itn/register/consent errors (400 > 50/10m)"
      frequency   = 10
      time_window = 10
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/register/consent"
            | where ResultCode == "400"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 50
      }
      email_subject = "[PARI] Portal Consent GET /consent alert (400)"
    }

    pari_product_files_upload_5m_rules_alert = {
      name        = "pari-product-files-upload-5xx-401-429-alert"
      description = "Product files upload API: 5xx/401/429 error threshold exceeded (> 5/5m)"
      severity    = 2
      query       = <<-QUERY
            AppRequests
            | where Name == "POST /idpay-itn/register/product-files"
            | where ResultCode startswith "5" or ResultCode in ("401", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI] Product files – upload API alert (5xx/401/429)"
    }

    pari_product_files_upload_10m_rule_alert = {
      name        = "pari-product-files-upload-400-alert"
      description = "Product files upload API: 400 error threshold exceeded (> 50/10m)"
      severity    = 2
      frequency   = 10
      time_window = 10
      query       = <<-QUERY
            AppRequests
            | where Name == "POST /idpay-itn/register/product-files"
            | where ResultCode == "400"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 50
      }
      email_subject = "[PARI] Product files – upload API alert (400)"
    }

    pari_product_files_verify_alert = {
      name        = "pari-product-files-verify-alert"
      description = "Product files verify API: error threshold exceeded (5xx > 3/5m)"
      severity    = 2
      query       = <<-QUERY
            AppRequests
            | where Name == "POST /idpay-itn/register/product-files/verify"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 3
      }
      email_subject = "[PARI] Product files verify alert"
    }

    pari_product_files_list_alert = {
      name        = "pari-product-files-list-alert"
      description = "Product files list API: 5xx error count exceeded (> 5 in 5m)"
      severity    = 2
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/register/product-files"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI] Product files – list API alert (5xx)"
    }

    pari_products_update_status_alert = {
      name        = "pari-products-update-status-alert"
      description = "Products update status API: error threshold exceeded (5xx > 3/5m per endpoint)"
      severity    = 3
      query       = <<-QUERY
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
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 3
      }
      email_subject = "[PARI] Products update status alert"
    }

    pari_get_products_5xx_alert = {
      name        = "pari-get-products-5xx-alert"
      description = "GET /products API: 5xx error count exceeded (> 5 in 5m)"
      severity    = 0
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/register/products"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][CRITICAL] GET /products alert: High 5xx errors"
    }

    pari_get_products_400_alert = {
      name        = "pari-get-products-400-alert"
      description = "GET /products API: 400 error count exceeded (> 50 in 10m)"
      severity    = 0
      time_window = 10
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/register/products"
            | where ResultCode == "400"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 50
      }
      email_subject = "[PARI][CRITICAL] GET /products alert: High 400 errors"
    }

    pari_get_products_availability_alert = {
      name        = "pari-get-products-availability-alert"
      description = "GET /products API: Availability dropped below 99% in the last 10 minutes"
      severity    = 0
      time_window = 10
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/register/products"
            | summarize TotalRequests = count(), SuccessfulRequests = countif(Success == true)
            | extend Availability = (todouble(SuccessfulRequests) / todouble(TotalRequests)) * 100
            | where Availability < 99
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 1
      }
      email_subject = "[PARI][CRITICAL] GET /products alert: Availability is below 99%"
    }

    pari_user_permissions_5m_rules_alert = {
      name        = "pari-user-permissions-5m-rules-alert"
      description = "User Permissions API: 5xx > 5/5m; 401/429 > 5/5m"
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/register/permissions"
            | where ResultCode startswith "5" or ResultCode in ("401", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][HIGH] User Permissions alert (5xx or 401/429)"
    }

    pari_user_permissions_10m_rule_alert = {
      name        = "pari-user-permissions-400-alert"
      description = "User Permissions API: 400 > 50/10m"
      time_window = 10
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/register/permissions"
            | where ResultCode == "400"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 50
      }
      email_subject = "[PARI][HIGH] User Permissions alert (400)"
    }

    pari_error_report_download_alert = {
      name        = "pari-error-report-download-alert"
      description = "Error report download API: 5xx error count exceeded (> 5 in 5m)"
      severity    = 3
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/register/product-files/*/report"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI] Error report download API alert (5xx)"
    }

    pari_batch_list_alert = {
      name        = "pari-batch-list-alert"
      description = "Batch list API: 5xx error count exceeded (> 5 in 5m)"
      severity    = 3
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/register/product-files/batch-list"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI] Batch list API alert (5xx)"
    }

    pari_institution_by_id_alert = {
      name        = "pari-institution-by-id-alert"
      description = "Institution by ID API: 5xx error count exceeded (> 5 in 5m)"
      severity    = 3
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/register/institutions/*"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI] Institution by ID API alert (5xx)"
    }

    pari_institutions_list_alert = {
      name        = "pari-institutions-list-alert"
      description = "Institutions list API: 5xx error count exceeded (> 5 in 5m)"
      severity    = 3
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/register/institutions"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI] Institutions list API alert (5xx)"
    }
  }

  alerts_misc = {
    pari_email_dependency_alert = {
      name        = "pari-email-dependency-alert"
      description = "Internal email microservice: error count exceeded threshold (> 10 in 5m)"
      severity    = 2
      query       = <<-QUERY
            AppDependencies
            | where TimeGenerated > ago(5m)
            | where Target == "idpay-notification-email-microservice-chart:8080"
            | where Success == false
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 10
      }
      email_subject = "[PARI] Internal Email microservice dependency alert"
    }

    pari_eprel_dependency_alert = {
      name        = "pari-eprel-dependency-alert"
      description = "EPREL dependency: error count exceeded threshold (> 10 in 5m)"
      query       = <<-QUERY
            AppDependencies
            | where TimeGenerated > ago(5m)
            | where Target == "eprel.ec.europa.eu"
            | where Success == false
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 10
      }
      email_subject = "[PARI][HIGH] EPREL external dependency alert"
    }
  }

  alerts_merchant_op = {
    capture_transaction_5xx_alert = {
      name        = "capture-transaction-5xx-alert"
      description = "API Capture Transaction: 5xx error count exceeded (> 2 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^PUT /idpay-itn/merchant-op/transactions/bar-code/[^/]+/capture$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 2
      }
      email_subject = "[PARI][ESE][HIGH] Capture Transaction API Alert (5xx)"
    }

    capture_transaction_4xx_alert = {
      name        = "capture-transaction-4xx-auth-alert"
      description = "API Capture Transaction: 401/404/429 error count exceeded (> 20 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^PUT /idpay-itn/merchant-op/transactions/bar-code/[^/]+/capture$"
            | where ResultCode in ("401", "404", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 20
      }
      email_subject = "[PARI][ESE][HIGH] Capture Transaction API Alert (4xx)"
    }

    preview_payment_5xx_alert = {
      name        = "preview-payment-5xx-alert"
      description = "API Preview Payment: 5xx error count exceeded (> 2 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^PUT /idpay-itn/merchant-op/transactions/bar-code/[^/]+/preview$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 2
      }
      email_subject = "[PARI][ESE][HIGH] Preview Payment API Alert (5xx)"
    }

    preview_payment_4xx_alert = {
      name        = "preview-payment-4xx-auth-alert"
      description = "API Preview Payment: 401/429 error count exceeded (> 20 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^PUT /idpay-itn/merchant-op/transactions/bar-code/[^/]+/preview$"
            | where ResultCode in ("401", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 20
      }
      email_subject = "[PARI][ESE][HIGH] Preview Payment API Alert (4xx)"
    }

    authorize_payment_5xx_alert = {
      name        = "authorize-payment-5xx-alert"
      description = "API Authorize Payment: 5xx error count exceeded (> 2 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^PUT /idpay-itn/merchant-op/transactions/bar-code/[^/]+/authorize$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 2
      }
      email_subject = "[PARI][ESE][HIGH] Authorize Payment API Alert (5xx)"
    }

    authorize_payment_4xx_alert = {
      name        = "authorize-payment-4xx-auth-alert"
      description = "API Authorize Payment: 401/403/404/429 error count exceeded (> 20 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^PUT /idpay-itn/merchant-op/transactions/bar-code/[^/]+/authorize$"
            | where ResultCode in ("401", "403", "404", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 20
      }
      email_subject = "[PARI][ESE][HIGH] Authorize Payment API Alert (4xx)"
    }

    pos_transactions_list_5xx_alert = {
      name        = "pos-transactions-inprogress-list-5xx-alert"
      description = "API POS In Progress Transactions List: 5xx error count exceeded (> 2 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/merchant-op/initiatives/[^/]+/point-of-sales/[^/]+/transactions$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 2
      }
      email_subject = "[PARI][ESE][HIGH] POS In Progress Transactions List API Alert (5xx)"
    }

    pos_transactions_list_4xx_alert = {
      name        = "pos-transactions-inprogress-list-4xx-alert"
      description = "API POS In Progress Transactions List: 401/404/429 error count exceeded (> 5 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/merchant-op/initiatives/[^/]+/point-of-sales/[^/]+/transactions$"
            | where ResultCode in ("401", "404", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][ESE][HIGH] POS In Progress Transactions List API Alert (4xx)"
    }

    pos_transactions_processed_5xx_alert = {
      name        = "pos-transactions-processed-5xx-alert"
      description = "API POS Processed Transactions List: 5xx error count exceeded (> 2 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/merchant-op/initiatives/[^/]+/point-of-sales/[^/]+/transactions/processed$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 2
      }
      email_subject = "[PARI][ESE][HIGH] POS Processed Transactions List API Alert (5xx)"
    }

    pos_transactions_processed_4xx_alert = {
      name        = "pos-transactions-processed-4xx-alert"
      description = "API POS Processed Transactions List: 401/404/429 error count exceeded (> 5 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/merchant-op/initiatives/[^/]+/point-of-sales/[^/]+/transactions/processed$"
            | where ResultCode in ("401", "404", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][ESE][HIGH] POS Processed Transactions List API Alert (4xx)"
    }

    delete_transaction_5xx_alert = {
      name        = "delete-transaction-5xx-alert"
      description = "API Delete Transaction: 5xx error count exceeded (> 2 in 5m)"
      severity    = 3
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^DELETE /idpay-itn/merchant-op/transactions/[^/]+$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 2
      }
      email_subject = "[PARI][ESE][LOW] Delete Transaction API Alert (5xx)"
    }

    delete_transaction_4xx_alert = {
      name        = "delete-transaction-4xx-alert"
      description = "API Delete Transaction: 401/403/404/429 error count exceeded (> 5 in 5m)"
      severity    = 3
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^DELETE /idpay-itn/merchant-op/transactions/[^/]+$"
            | where ResultCode in ("401", "403", "404", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][ESE][LOW] Delete Transaction API Alert (4xx)"
    }

    reversal_transaction_5xx_alert = {
      name        = "reversal-transaction-5xx-alert"
      description = "API Reversal Transaction: 5xx error count exceeded (> 2 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^POST /idpay-itn/merchant-op/transactions/[^/]+/reversal$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 2
      }
      email_subject = "[PARI][ESE][HIGH] Reversal Transaction API Alert (5xx)"
    }

    reward_transaction_5xx_alert = {
      name        = "reward-transaction-5xx-alert"
      description = "API Reward Transaction: 5xx error count exceeded (> 2 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^POST /idpay-itn/merchant-op/transactions/[^/]+/reward$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 2
      }
      email_subject = "[PARI][ESE][HIGH] Reward Transaction API Alert (5xx)"
    }

    products_list_5xx_alert = {
      name        = "products-list-5xx-alert"
      description = "API Products List: 5xx error count exceeded (> 2 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/merchant-op/products"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 2
      }
      email_subject = "[PARI][ESE][HIGH] Products List API Alert (5xx)"
    }

    products_list_4xx_alert = {
      name        = "products-list-4xx-alert"
      description = "API Products List: 401/404/429 error count exceeded (> 15 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/merchant-op/products"
            | where ResultCode in ("401", "404", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 15
      }
      email_subject = "[PARI][ESE][HIGH] Products List API Alert (4xx)"
    }
  }

  alerts_merchant = {
    download_invoice_5xx_alert = {
      name        = "download-invoice-file-5xx-alert"
      description = "API Download Invoice File: 5xx error count exceeded (> 2 in 5m)"
      severity    = 3
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/merchant/portal/[^/]+/transactions/[^/]+/download$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 2
      }
      email_subject = "[PARI][ESE][LOW] Download Invoice File API Alert (5xx)"
    }

    download_invoice_4xx_alert = {
      name        = "download-invoice-file-4xx-alert"
      description = "API Download Invoice File: 400/401/429 error count exceeded (> 1 in 5m)"
      severity    = 3
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/merchant/portal/[^/]+/transactions/[^/]+/download$"
            | where ResultCode in ("400", "401", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 1
      }
      email_subject = "[PARI][ESE][LOW] Download Invoice File API Alert (4xx)"
    }

    retrieve_pos_5xx_alert = {
      name        = "retrieve-point-of-sale-5xx-alert"
      description = "API Retrieve a point of sale: 5xx error count exceeded (> 2 in 5m)"
      severity    = 3
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/merchant/portal/[^/]+/point-of-sales/[^/]+$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 2
      }
      email_subject = "[PARI][ESE][LOW] Retrieve a point of sale API Alert (5xx)"
    }

    retrieve_pos_4xx_alert = {
      name        = "retrieve-point-of-sale-4xx-alert"
      description = "API Retrieve a point of sale: 401/404/429 error count exceeded (> 3 in 5m)"
      severity    = 3
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/merchant/portal/[^/]+/point-of-sales/[^/]+$"
            | where ResultCode in ("401", "404", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 3
      }
      email_subject = "[PARI][ESE][LOW] Retrieve a point of sale API Alert (4xx)"
    }
  }

  alerts_onboarding = {
    get_initiative_id_5xx_alert = {
      name        = "get-initiative-id-5xx-alert"
      description = "API Get Initiative ID: 5xx error count exceeded (> 2 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/onboarding/service/[^/]+$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 2
      }
      email_subject = "[PARI][UPBE][HIGH] Get Initiative ID API Alert (5xx)"
    }

    get_initiative_id_400_alert = {
      name        = "get-initiative-id-400-alert"
      description = "API Get Initiative ID: 400 error count exceeded (> 50 in 10m)"
      time_window = 10
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/onboarding/service/[^/]+$"
            | where ResultCode == "400"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 50
      }
      email_subject = "[PARI][UPBE][HIGH] Get Initiative ID API Alert (400)"
    }

    get_initiative_id_4xx_auth_alert = {
      name        = "get-initiative-id-4xx-auth-alert"
      description = "API Get Initiative ID: 401/429 error count exceeded (> 5 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/onboarding/service/[^/]+$"
            | where ResultCode in ("401", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][UPBE][HIGH] Get Initiative ID API Alert (401/429)"
    }

    get_initiative_detail_5xx_alert = {
      name        = "get-initiative-detail-5xx-alert"
      description = "API Get Initiative Detail: 5xx error count exceeded (> 2 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/onboarding/[^/]+/detail$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 2
      }
      email_subject = "[PARI][UPBE][HIGH] Get Initiative Detail API Alert (5xx)"
    }

    get_initiative_detail_400_alert = {
      name        = "get-initiative-detail-400-alert"
      description = "API Get Initiative Detail: 400 error count exceeded (> 50 in 10m)"
      time_window = 10
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/onboarding/[^/]+/detail$"
            | where ResultCode == "400"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 50
      }
      email_subject = "[PARI][UPBE][HIGH] Get Initiative Detail API Alert (400)"
    }

    get_initiative_detail_4xx_auth_alert = {
      name        = "get-initiative-detail-4xx-auth-alert"
      description = "API Get Initiative Detail: 401/429 error count exceeded (> 5 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/onboarding/[^/]+/detail$"
            | where ResultCode in ("401", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][UPBE][HIGH] Get Initiative Detail API Alert (401/429)"
    }

    save_onboarding_5xx_alert = {
      name        = "save-onboarding-5xx-alert"
      description = "API Save Onboarding: 5xx error count exceeded (> 5 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name == "PUT /idpay-itn/onboarding/"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][UPBE][HIGH] Save Onboarding API Alert (5xx)"
    }

    save_onboarding_400_alert = {
      name        = "save-onboarding-400-alert"
      description = "API Save Onboarding: 400 error count exceeded (> 50 in 10m)"
      time_window = 10
      query       = <<-QUERY
            AppRequests
            | where Name == "PUT /idpay-itn/onboarding/"
            | where ResultCode == "400"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 50
      }
      email_subject = "[PARI][UPBE][HIGH] Save Onboarding API Alert (400)"
    }

    save_onboarding_4xx_auth_alert = {
      name        = "save-onboarding-4xx-auth-alert"
      description = "API Save Onboarding: 401/429 error count exceeded (> 5 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name == "PUT /idpay-itn/onboarding/"
            | where ResultCode in ("401", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][UPBE][HIGH] Save Onboarding API Alert (401/429)"
    }

    onboarding_status_5xx_alert = {
      name        = "onboarding-status-5xx-alert"
      description = "API Onboarding Status: 5xx error count exceeded (> 5 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/onboarding/[^/]+/status$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][UPBE][HIGH] Onboarding Status API Alert (5xx)"
    }

    onboarding_status_4xx_auth_alert = {
      name        = "onboarding-status-4xx-auth-alert"
      description = "API Onboarding Status: 401/429 error count exceeded (> 5 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/onboarding/[^/]+/status$"
            | where ResultCode in ("401", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][UPBE][HIGH] Onboarding Status API Alert (401/429)"
    }

    onboarding_initiative_user_status_5xx_alert = {
      name        = "onboarding-initiative-user-status-5xx-alert"
      description = "API Onboarding Initiative User Status: 5xx error count exceeded (> 2 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/onboarding/user/initiative/status"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 2
      }
      email_subject = "[PARI][UPBE][HIGH] Onboarding Initiative User Status API Alert (5xx)"
    }

    onboarding_initiative_user_status_400_alert = {
      name        = "onboarding-initiative-user-status-400-alert"
      description = "API Onboarding Initiative User Status: 400 error count exceeded (> 50 in 10m)"
      time_window = 10
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/onboarding/user/initiative/status"
            | where ResultCode == "400"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 50
      }
      email_subject = "[PARI][UPBE][HIGH] Onboarding Initiative User Status API Alert (400)"
    }

    onboarding_initiative_user_status_4xx_auth_alert = {
      name        = "onboarding-initiative-user-status-4xx-auth-alert"
      description = "API Onboarding Initiative User Status: 401/429 error count exceeded (> 5 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/onboarding/user/initiative/status"
            | where ResultCode in ("401", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][UPBE][HIGH] Onboarding Initiative User Status API Alert (401/429)"
    }
  }

  alerts_timeline = {
    get_timeline_5xx_alert = {
      name        = "get-timeline-5xx-alert"
      description = "API Get Timeline: 5xx error count exceeded (> 3 in 5m)"
      severity    = 2
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/timeline/[^/]+$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 3
      }
      email_subject = "[PARI][UPBE][MEDIUM] Get Timeline API Alert (5xx)"
    }
  }

  alerts_wallet = {
    get_wallet_5xx_alert = {
      name        = "get-wallet-5xx-alert"
      description = "API Get Wallet: 5xx error count exceeded (> 3 in 5m)"
      severity    = 2
      query       = <<-QUERY
            AppRequests
            | where Name == "GET /idpay-itn/wallet/"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 3
      }
      email_subject = "[PARI][UPBE][MEDIUM] Get Wallet API Alert (5xx)"
    }

    get_initiative_beneficiary_detail_5xx_alert = {
      name        = "get-initiative-beneficiary-detail-5xx-alert"
      description = "API Get Initiative Beneficiary Detail: 5xx error count exceeded (> 5 in 5m)"
      severity    = 2
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/wallet/[^/]+/detail$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][UPBE][MEDIUM] Get Initiative Beneficiary Detail API Alert (5xx)"
    }

    get_initiative_beneficiary_detail_400_alert = {
      name        = "get-initiative-beneficiary-detail-400-alert"
      description = "API Get Initiative Beneficiary Detail: 400 error count exceeded (> 50 in 10m)"
      severity    = 2
      time_window = 10
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/wallet/[^/]+/detail$"
            | where ResultCode == "400"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 50
      }
      email_subject = "[PARI][UPBE][MEDIUM] Get Initiative Beneficiary Detail API Alert (400)"
    }

    get_initiative_beneficiary_detail_4xx_auth_alert = {
      name        = "get-initiative-beneficiary-detail-4xx-auth-alert"
      description = "API Get Initiative Beneficiary Detail: 401/429 error count exceeded (> 5 in 5m)"
      severity    = 2
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/wallet/[^/]+/detail$"
            | where ResultCode in ("401", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][UPBE][MEDIUM] Get Initiative Beneficiary Detail API Alert (401/429)"
    }

    get_wallet_detail_5xx_alert = {
      name        = "get-wallet-detail-5xx-alert"
      description = "API Get Wallet Detail: 5xx error count exceeded (> 5 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/wallet/[^/]+$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][UPBE][HIGH] Get Wallet Detail API Alert (5xx)"
    }

    get_wallet_detail_400_alert = {
      name        = "get-wallet-detail-400-alert"
      description = "API Get Wallet Detail: 400 error count exceeded (> 50 in 10m)"
      time_window = 10
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/wallet/[^/]+$"
            | where ResultCode == "400"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 50
      }
      email_subject = "[PARI][UPBE][HIGH] Get Wallet Detail API Alert (400)"
    }

    get_wallet_detail_4xx_auth_alert = {
      name        = "get-wallet-detail-4xx-auth-alert"
      description = "API Get Wallet Detail: 401/429 error count exceeded (> 5 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/wallet/[^/]+$"
            | where ResultCode in ("401", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][UPBE][HIGH] Get Wallet Detail API Alert (401/429)"
    }
  }

  alerts_payment = {
    create_barcode_transaction_5xx_alert = {
      name        = "create-barcode-transaction-5xx-alert"
      description = "API Create Barcode Transaction: 5xx error count exceeded (> 5 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name == "POST /idpay-itn/payment/bar-code"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][UPBE][HIGH] Create Barcode Transaction API Alert (5xx)"
    }

    create_barcode_transaction_400_alert = {
      name        = "create-barcode-transaction-400-alert"
      description = "API Create Barcode Transaction: 400 error count exceeded (> 50 in 10m)"
      time_window = 10
      query       = <<-QUERY
            AppRequests
            | where Name == "POST /idpay-itn/payment/bar-code"
            | where ResultCode == "400"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 50
      }
      email_subject = "[PARI][UPBE][HIGH] Create Barcode Transaction API Alert (400)"
    }

    create_barcode_transaction_4xx_auth_alert = {
      name        = "create-barcode-transaction-4xx-auth-alert"
      description = "API Create Barcode Transaction: 401/429 error count exceeded (> 5 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name == "POST /idpay-itn/payment/bar-code"
            | where ResultCode in ("401", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][UPBE][HIGH] Create Barcode Transaction API Alert (401/429)"
    }

    retrieve_active_barcode_transaction_5xx_alert = {
      name        = "retrieve-active-barcode-transaction-5xx-alert"
      description = "API Retrieve Active Barcode Transaction: 5xx error count exceeded (> 5 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/payment/initiatives/[^/]+/bar-code$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][UPBE][HIGH] Retrieve Active Barcode Transaction API Alert (5xx)"
    }

    retrieve_active_barcode_transaction_400_alert = {
      name        = "retrieve-active-barcode-transaction-400-alert"
      description = "API Retrieve Active Barcode Transaction: 400 error count exceeded (> 50 in 10m)"
      time_window = 10
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/payment/initiatives/[^/]+/bar-code$"
            | where ResultCode == "400"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 50
      }
      email_subject = "[PARI][UPBE][HIGH] Retrieve Active Barcode Transaction API Alert (400)"
    }

    retrieve_active_barcode_transaction_4xx_auth_alert = {
      name        = "retrieve-active-barcode-transaction-4xx-auth-alert"
      description = "API Retrieve Active Barcode Transaction: 401/429 error count exceeded (> 5 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/payment/initiatives/[^/]+/bar-code$"
            | where ResultCode in ("401", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][UPBE][HIGH] Retrieve Active Barcode Transaction API Alert (401/429)"
    }
  }

  alerts_web = {
    get_transaction_pdf_5xx_alert = {
      name        = "get-transaction-pdf-5xx-alert"
      description = "API Get Transaction PDF: 5xx error count exceeded (> 5 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/web/payment/initiatives/[^/]+/bar-code/[^/]+/pdf$"
            | where ResultCode startswith "5"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][UPBE][HIGH] Get Transaction PDF API Alert (5xx)"
    }

    get_transaction_pdf_400_alert = {
      name        = "get-transaction-pdf-400-alert"
      description = "API Get Transaction PDF: 400 error count exceeded (> 50 in 10m)"
      time_window = 10
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/web/payment/initiatives/[^/]+/bar-code/[^/]+/pdf$"
            | where ResultCode == "400"
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 50
      }
      email_subject = "[PARI][UPBE][HIGH] Get Transaction PDF API Alert (400)"
    }

    get_transaction_pdf_4xx_auth_alert = {
      name        = "get-transaction-pdf-4xx-auth-alert"
      description = "API Get Transaction PDF: 401/429 error count exceeded (> 5 in 5m)"
      query       = <<-QUERY
            AppRequests
            | where Name matches regex @"^GET /idpay-itn/web/payment/initiatives/[^/]+/bar-code/[^/]+/pdf$"
            | where ResultCode in ("401", "429")
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }
      email_subject = "[PARI][UPBE][HIGH] Get Transaction PDF API Alert (401/429)"
    }
  }

  alerts_keycloak = {
    keycloak_catchall_user_realm_alert = {
      name        = "keycloak-catchall-user-realm-alert"
      description = "Keycloak (Catch-All 'user' realm): Total failure count exceeded (> 100 in 5m)"
      severity    = 2

      data_source_id = data.azurerm_application_insights.core_app_insights.id

      query = format(<<-QUERY
          requests
          | where appName == "%s"
          | where tostring(customDimensions.["kc.realmName"]) in ("user")
          | where not(operation_Name has "admin")
          | where success == false
        QUERY
        , data.azurerm_application_insights.core_app_insights.id
      )

      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 100
      }

      email_subject = "[PARI][KEYCLOAK][MEDIUM] Keycloak Catch-All 'user' Realm Alert (Failures)"
    }

    keycloak_catchall_merchant_operator_realm_alert = {
      name        = "keycloak-catchall-merchant-operator-realm-alert"
      description = "Keycloak (Catch-All 'merchant-operator' realm): Total failure count exceeded (> 100 in 5m)"
      severity    = 2

      data_source_id = data.azurerm_application_insights.core_app_insights.id

      query = format(<<-QUERY
          requests
          | where appName == "%s"
          | where tostring(customDimensions.["kc.realmName"]) in ("merchant-operator")
          | where not(operation_Name has "admin")
          | where success == false
        QUERY
        , data.azurerm_application_insights.core_app_insights.id
      )

      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 100
      }

      email_subject = "[PARI][KEYCLOAK][MEDIUM] Keycloak Catch-All 'merchant-operator' Realm Alert (Failures)"
    }
  }

  alerts_keycloak_token_user_realm = {
    keycloak_token_user_realm_alert = {
      name        = "keycloak-token-user-realm-alert"
      description = "Keycloak (/token 'user' realm): Total failure count exceeded (> 5 in 5m)"

      data_source_id = data.azurerm_application_insights.core_app_insights.id

      query = format(<<-QUERY
            requests
            | where appName == "%s"
            | where tostring(customDimensions.["kc.realmName"]) in ("user")
            | where not(operation_Name has "admin")
            | where name == "POST /realms/{realm}/protocol/{protocol}/token"
            | where success == false
          QUERY
        , data.azurerm_application_insights.core_app_insights.id
      )

      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }

      email_subject = "[PARI][KEYCLOAK][HIGH] Keycloak /token 'user' Realm Alert (Failures)"
    }
  }

  alerts_keycloak_token_merchant_operator_realm = {
    keycloak_token_merchant_operator_realm_alert = {
      name        = "keycloak-token-merchant-operator-realm-alert"
      description = "Keycloak (/token 'merchant-operator' realm): Total failure count exceeded (> 5 in 5m)"

      data_source_id = data.azurerm_application_insights.core_app_insights.id

      query = format(<<-QUERY
            requests
            | where appName == "%s"
            | where tostring(customDimensions.["kc.realmName"]) in ("merchant-operator")
            | where not(operation_Name has "admin")
            | where name == "POST /realms/{realm}/protocol/{protocol}/token"
            | where success == false
          QUERY
        , data.azurerm_application_insights.core_app_insights.id
      )

      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }

      email_subject = "[PARI][KEYCLOAK][HIGH] Keycloak /token 'merchant-operator' Realm Alert (Failures)"
    }
  }

  alerts_keycloak_login_user_realm = {
    keycloak_login_user_realm_alert = {
      name        = "keycloak-login-user-realm-alert"
      description = "Keycloak (/login 'user' realm): Total failure count exceeded (> 5 in 5m)"

      data_source_id = data.azurerm_application_insights.core_app_insights.id

      query = format(<<-QUERY
            requests
            | where appName == "%s"
            | where tostring(customDimensions.["kc.realmName"]) in ("user")
            | where not(operation_Name has "admin")
            | where name == "GET /realms/{realm}/broker/{provider_alias}/login"
            | where success == false
          QUERY
        , data.azurerm_application_insights.core_app_insights.id
      )

      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }

      email_subject = "[PARI][KEYCLOAK][HIGH] Keycloak /login 'user' Realm Alert (Failures)"
    }
  }

  alerts_keycloak_endpoint_user_realm = {
    keycloak_endpoint_user_realm_alert = {
      name        = "keycloak-endpoint_user-realm-alert"
      description = "Keycloak (/endpoint 'user' realm): Total failure count exceeded (> 5 in 5m)"

      data_source_id = data.azurerm_application_insights.core_app_insights.id

      query = format(<<-QUERY
            requests
            | where appName == "%s"
            | where tostring(customDimensions.["kc.realmName"]) in ("user")
            | where not(operation_Name has "admin")
            | where name == "GET /realms/{realm}/broker/{provider_alias}/endpoint"
            | where success == false
          QUERY
        , data.azurerm_application_insights.core_app_insights.id
      )

      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 5
      }

      email_subject = "[PARI][KEYCLOAK][HIGH] Keycloak /endpoint 'user' Realm Alert (Failures)"
    }
  }

  alerts_groups = [
    local.alerts_register,
    local.alerts_misc,
    local.alerts_merchant_op,
    local.alerts_merchant,
    local.alerts_onboarding,
    local.alerts_timeline,
    local.alerts_wallet,
    local.alerts_payment,
    local.alerts_web,
    local.alerts_keycloak,
    local.alerts_keycloak_token_user_realm,
    local.alerts_keycloak_token_merchant_operator_realm,
    local.alerts_keycloak_login_user_realm,
    local.alerts_keycloak_endpoint_user_realm
  ]

  alert_definitions = merge([
    for alerts in local.alerts_groups : {
      for key, alert in alerts : key => merge(local.alert_defaults, alert)
    }
  ]...)
}
