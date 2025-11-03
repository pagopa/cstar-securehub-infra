# =============================================================
# Alert API EIE
# =============================================================

locals {
  alert_action_group = compact([
    try(data.azurerm_monitor_action_group.alerts_email[0].id, null),
    var.env_short == "p" ? try(data.azurerm_monitor_action_group.alerts_opsgenie[0].id, null) : null
  ])

  alert_defaults = {
    enabled     = true
    severity    = 1
    frequency   = 5
    time_window = 5
  }

  ### Alerts by microservice
  alerts_microservices = {
    # Register
    register = {
      # Portal Consent
      portal_consent = {
        # Portal Consent – post (5xx, 401, 429 errors over 5 minutes)
        portal_consent_save_5m_rules = merge(local.alert_defaults, {
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
        })

        # Portal Consent – post (400 errors over 10 minutes)
        portal_consent_save_10m_rule = merge(local.alert_defaults, {
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
        })

        # Portal Consent – get (5xx, 401, 429 errors over 5 minutes)
        pari_portal_consent_get_5m_rules_alert = merge(local.alert_defaults, {
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
        })

        # Portal Consent – get (400 errors over 10 minutes)
        pari_portal_consent_get_10m_rule_alert = merge(local.alert_defaults, {
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
        })
      }

      # Product files
      product_files = {
        # Product files – upload (5xx, 401, 429 errors over 5 minutes)
        pari_product_files_upload_5m_rules_alert = merge(local.alert_defaults, {
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
        })

        # Product files – upload (400 errors over 10 minutes)
        pari_product_files_upload_10m_rule_alert = merge(local.alert_defaults, {
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
        })

        # Product files – verify
        pari_product_files_verify_alert = merge(local.alert_defaults, {
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
        })

        # Product files – list
        pari_product_files_list_alert = merge(local.alert_defaults, {
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
        })
      }

      # Products
      products = {
        # Products – update status
        pari_products_update_status_alert = merge(local.alert_defaults, {
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
        })
      }

      # GET products
      get_products = {
        # GET products - 5xx Error Count
        pari_get_products_5xx_alert = merge(local.alert_defaults, {
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
        })

        # GET products - 400 Error Count
        pari_get_products_400_alert = merge(local.alert_defaults, {
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
        })

        # GET products - Availability
        pari_get_products_availability_alert = merge(local.alert_defaults, {
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
        })
      }

      # User Permissions
      user_permissions = {
        # User Permissions - 5xx, 401, 429 errors over 5 minutes
        pari_user_permissions_5m_rules_alert = merge(local.alert_defaults, {
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
        })

        # User Permissions - 400 errors over 10 minutes
        pari_user_permissions_10m_rule_alert = merge(local.alert_defaults, {
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
        })
      }

      # Error report download
      error_report_download = {
        # Error report download
        pari_error_report_download_alert = merge(local.alert_defaults, {
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
        })
      }

      # Batch list
      batch_list = {
        # Batch list
        pari_batch_list_alert = merge(local.alert_defaults, {
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
        })
      }

      # Institution by ID
      institution_by_id = {
        # Institution by ID
        pari_institution_by_id_alert = merge(local.alert_defaults, {
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
        })
      }

      # Institutions list
      institutions_list = {
        # Institutions list
        pari_institutions_list_alert = merge(local.alert_defaults, {
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
        })
      }
    }

    # Misc
    misc = {
      # Internal dependency
      internal_dependency = {
        # Internal dependency – E-mail service
        pari_email_dependency_alert = merge(local.alert_defaults, {
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
        })
      }

      # External dependency
      external_dependency = {
        # External dependency  – EPREL
        pari_eprel_dependency_alert = merge(local.alert_defaults, {
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
        })
      }
    }

    # Merchant Op
    merchant_op = {
      # Capture the transaction
      capture_the_transaction = {
        # Capture the transaction - 5xx Error Count
        capture_transaction_5xx_alert = merge(local.alert_defaults, {
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
        })

        # Capture the transaction - 401/404/429 Error Count
        capture_transaction_4xx_alert = merge(local.alert_defaults, {
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
        })
      }

      # Preview Payment
      preview_payment = {
        # Preview Payment - 5xx Error Count
        preview_payment_5xx_alert = merge(local.alert_defaults, {
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
        })

        # Preview Payment - 401/429 Error Count
        preview_payment_4xx_alert = merge(local.alert_defaults, {
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
        })
      }

      # Authorize payment
      authorize_payment = {
        # Authorize payment - 5xx Error Count
        authorize_payment_5xx_alert = merge(local.alert_defaults, {
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
        })

        # Authorize payment - 4xx Error Count
        authorize_payment_4xx_alert = merge(local.alert_defaults, {
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
        })
      }

      # POS In Progress Transactions List
      pos_in_progress_transactions_list = {
        # POS In Progress Transactions List - 5xx Error Count
        pos_transactions_list_5xx_alert = merge(local.alert_defaults, {
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
        })

        # POS In Progress Transactions List - 4xx Error Count
        pos_transactions_list_4xx_alert = merge(local.alert_defaults, {
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
        })
      }

      # POS Processed Transactions List
      pos_processed_transactions_list = {
        # POS Processed Transactions List - 5xx Error Count
        pos_transactions_processed_5xx_alert = merge(local.alert_defaults, {
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
        })

        # POS Processed Transactions List - 4xx Error Count
        pos_transactions_processed_4xx_alert = merge(local.alert_defaults, {
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
        })
      }

      # Delete Transaction
      delete_transaction = {
        # Delete Transaction - 5xx Error Count
        delete_transaction_5xx_alert = merge(local.alert_defaults, {
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
        })

        # Delete Transaction - 4xx Error Count
        delete_transaction_4xx_alert = merge(local.alert_defaults, {
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
        })
      }

      # Reversal Transaction
      reversal_transaction = {
        # Reversal Transaction - 5xx Error Count
        reversal_transaction_5xx_alert = merge(local.alert_defaults, {
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
        })
      }

      # Reward Transaction
      reward_transaction = {
        # Reward Transaction - 5xx Error Count
        reward_transaction_5xx_alert = merge(local.alert_defaults, {
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
        })
      }

      # Products List
      products_list = {
        # Products List - 5xx Error Count
        products_list_5xx_alert = merge(local.alert_defaults, {
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
        })

        # Products List - 4xx Error Count
        products_list_4xx_alert = merge(local.alert_defaults, {
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
        })
      }
    }

    # Merchant
    merchant = {
      # Download invoice file
      download_invoice_file = {
        # Download invoice file - 5xx Error Count
        download_invoice_5xx_alert = merge(local.alert_defaults, {
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
        })

        # Download invoice file - 4xx Error Count
        download_invoice_4xx_alert = merge(local.alert_defaults, {
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
        })
      }

      # Retrieve a point of sale
      retrieve_a_point_of_sale = {
        # Retrieve a point of sale - 5xx Error Count
        retrieve_pos_5xx_alert = merge(local.alert_defaults, {
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
        })

        # Retrieve a point of sale - 4xx Error Count
        retrieve_pos_4xx_alert = merge(local.alert_defaults, {
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
        })
      }
    }

    # Onboarding
    onboarding = {
      # Get Initiative ID (Onboarding Service)
      get_initiative_id_onboarding_service = {
        # Get Initiative ID (Onboarding Service) - 5xx Error Count
        get_initiative_id_5xx_alert = merge(local.alert_defaults, {
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
        })

        # Get Initiative ID (Onboarding Service) - 400 Error Count
        get_initiative_id_400_alert = merge(local.alert_defaults, {
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
        })

        # Get Initiative ID (Onboarding Service) - 401/429 Error Count
        get_initiative_id_4xx_auth_alert = merge(local.alert_defaults, {
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
        })
      }

      # Get Initiative Detail (Onboarding Service)
      get_initiative_detail_onboarding_service = {
        # Get Initiative Detail (Onboarding Service) - 5xx Error Count
        get_initiative_detail_5xx_alert = merge(local.alert_defaults, {
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
        })

        # Get Initiative Detail (Onboarding Service) - 400 Error Count
        get_initiative_detail_400_alert = merge(local.alert_defaults, {
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
        })

        # Get Initiative Detail (Onboarding Service) - 401/429 Error Count
        get_initiative_detail_4xx_auth_alert = merge(local.alert_defaults, {
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
        })
      }

      # Save Onboarding
      save_onboarding = {
        # Save Onboarding - 5xx Error Count
        save_onboarding_5xx_alert = merge(local.alert_defaults, {
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
        })

        # Save Onboarding - 400 Error Count
        save_onboarding_400_alert = merge(local.alert_defaults, {
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
        })

        # Save Onboarding - 401/429 Error Count
        save_onboarding_4xx_auth_alert = merge(local.alert_defaults, {
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
        })
      }

      # Onboarding Status
      onboarding_status = {
        # Onboarding Status - 5xx Error Count
        onboarding_status_5xx_alert = merge(local.alert_defaults, {
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
        })

        # Onboarding Status - 401/429 Error Count
        onboarding_status_4xx_auth_alert = merge(local.alert_defaults, {
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
        })
      }

      # Onboarding Initiative User Status
      onboarding_initiative_user_status = {
        # Onboarding Initiative User Status - 5xx Error Count
        onboarding_initiative_user_status_5xx_alert = merge(local.alert_defaults, {
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
        })

        # Onboarding Initiative User Status - 400 Error Count
        onboarding_initiative_user_status_400_alert = merge(local.alert_defaults, {
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
        })

        # Onboarding Initiative User Status - 401/429 Error Count
        onboarding_initiative_user_status_4xx_auth_alert = merge(local.alert_defaults, {
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
        })
      }
    }

    # Timeline
    timeline = {
      # Get Timeline
      get_timeline = {
        # Get Timeline - 5xx Error Count
        get_timeline_5xx_alert = merge(local.alert_defaults, {
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
        })
      }
    }

    # Wallet
    wallet = {
      # Get Wallet
      get_wallet = {
        # Get Wallet - 5xx Error Count
        get_wallet_5xx_alert = merge(local.alert_defaults, {
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
        })
      }

      # Get Initiative Beneficiary Detail
      get_initiative_beneficiary_detail = {
        # Get Initiative Beneficiary Detail - 5xx Error Count
        get_initiative_beneficiary_detail_5xx_alert = merge(local.alert_defaults, {
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
        })

        # Get Initiative Beneficiary Detail - 400 Error Count
        get_initiative_beneficiary_detail_400_alert = merge(local.alert_defaults, {
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
        })

        # Get Initiative Beneficiary Detail - 401/429 Error Count
        get_initiative_beneficiary_detail_4xx_auth_alert = merge(local.alert_defaults, {
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
        })
      }

      # Get Wallet Detail
      get_wallet_detail = {
        # Get Wallet Detail - 5xx Error Count
        get_wallet_detail_5xx_alert = merge(local.alert_defaults, {
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
        })

        # Get Wallet Detail - 400 Error Count
        get_wallet_detail_400_alert = merge(local.alert_defaults, {
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
        })

        # Get Wallet Detail - 401/429 Error Count
        get_wallet_detail_4xx_auth_alert = merge(local.alert_defaults, {
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
        })
      }
    }

    # Payment
    payment = {
      # Create Barcode Transaction
      create_barcode_transaction = {
        # Create Barcode Transaction - 5xx Error Count
        create_barcode_transaction_5xx_alert = merge(local.alert_defaults, {
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
        })

        # Create Barcode Transaction - 400 Error Count
        create_barcode_transaction_400_alert = merge(local.alert_defaults, {
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
        })

        # Create Barcode Transaction - 401/429 Error Count
        create_barcode_transaction_4xx_auth_alert = merge(local.alert_defaults, {
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
        })
      }

      # Retrieve Active Barcode Transaction
      retrieve_active_barcode_transaction = {
        # Retrieve Active Barcode Transaction - 5xx Error Count
        retrieve_active_barcode_transaction_5xx_alert = merge(local.alert_defaults, {
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
        })

        # Retrieve Active Barcode Transaction - 400 Error Count
        retrieve_active_barcode_transaction_400_alert = merge(local.alert_defaults, {
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
        })

        # Retrieve Active Barcode Transaction - 401/429 Error Count
        retrieve_active_barcode_transaction_4xx_auth_alert = merge(local.alert_defaults, {
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
        })
      }
    }

    # Web
    web = {
      # Get Transaction PDF
      get_transaction_pdf = {
        # Get Transaction PDF - 5xx Error Count
        get_transaction_pdf_5xx_alert = merge(local.alert_defaults, {
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
        })

        # Get Transaction PDF - 400 Error Count
        get_transaction_pdf_400_alert = merge(local.alert_defaults, {
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
        })

        # Get Transaction PDF - 401/429 Error Count
        get_transaction_pdf_4xx_auth_alert = merge(local.alert_defaults, {
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
        })
      }
    }
  }

  alert_definitions = merge([
    for service in values(local.alerts_microservices) : merge([
      for group in values(service) : group
    ]...)
  ]...)
}
