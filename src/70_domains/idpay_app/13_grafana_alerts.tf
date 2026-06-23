locals {
  grafana_managed_name                 = "${local.product_no_domain}-grafana"
  grafana_managed_rg_name              = "${local.product_no_domain}-platform-monitoring-rg"
  grafana_core_kv_name                 = "${local.product_no_domain}-core-kv"
  grafana_core_kv_rg_name              = "${local.product_no_domain}-core-sec-rg"
  grafana_alert_folder_name            = "IDPay App Alerts"
  grafana_alert_contact_point_name     = "idpay-app-notifications"
  grafana_alert_rule_group_name        = "idpay-app-basic-alerts"
  grafana_alert_rule_name              = "idpay-app-placeholder-alert"
  grafana_alert_placeholder_expression = "0"
}

data "azurerm_dashboard_grafana" "grafana_managed" {
  name                = local.grafana_managed_name
  resource_group_name = local.grafana_managed_rg_name
}

data "azurerm_key_vault" "grafana_core" {
  name                = local.grafana_core_kv_name
  resource_group_name = local.grafana_core_kv_rg_name
}

data "azurerm_key_vault_secret" "grafana_service_account_token" {
  name         = "grafana-itn-service-account-token-value"
  key_vault_id = data.azurerm_key_vault.grafana_core.id
}

resource "grafana_folder" "idpay_app_alerts" {
  provider = grafana.cloud
  count    = var.idpay_grafana_alert_enabled ? 1 : 0

  title = local.grafana_alert_folder_name
}

resource "grafana_contact_point" "idpay_app_alerts" {
  provider = grafana.cloud
  count    = var.idpay_grafana_alert_enabled ? 1 : 0

  name = local.grafana_alert_contact_point_name

  email {
    addresses    = var.idpay_grafana_alert_email_addresses
    subject      = "{{ template \"default.title\" . }}"
    message      = "{{ template \"default.message\" . }}"
    single_email = true
  }

  slack {
    url   = var.idpay_grafana_alert_slack_webhook_url
    title = "{{ template \"default.title\" . }}"
    text  = "{{ template \"default.message\" . }}"
  }
}

resource "grafana_rule_group" "idpay_app_alerts" {
  provider = grafana.cloud
  count    = var.idpay_grafana_alert_enabled ? 1 : 0

  name             = local.grafana_alert_rule_group_name
  folder_uid       = grafana_folder.idpay_app_alerts[0].uid
  interval_seconds = 300

  rule {
    name           = local.grafana_alert_rule_name
    for            = "5m"
    condition      = "B"
    no_data_state  = "OK"
    exec_err_state = "Error"
    annotations = {
      description = "Replace expression A with the real datasource query before enabling this placeholder alert."
      summary     = "IDPay app placeholder Grafana alert"
    }
    labels = {
      domain   = var.domain
      service  = "idpay-app"
      severity = "warning"
      source   = "terraform"
    }

    notification_settings {
      contact_point = grafana_contact_point.idpay_app_alerts[0].name
    }

    # Replace this expression stage with the real datasource query when the alert is finalized.
    data {
      ref_id     = "A"
      query_type = ""
      relative_time_range {
        from = 0
        to   = 0
      }
      datasource_uid = "-100"
      model = jsonencode({
        datasource = {
          type = "__expr__"
          uid  = "-100"
        }
        expression    = local.grafana_alert_placeholder_expression
        hide          = false
        intervalMs    = 1000
        maxDataPoints = 43200
        refId         = "A"
        type          = "math"
      })
    }

    data {
      ref_id     = "B"
      query_type = ""
      relative_time_range {
        from = 0
        to   = 0
      }
      datasource_uid = "-100"
      model = jsonencode({
        conditions = [
          {
            evaluator = {
              params = [1]
              type   = "gt"
            }
            operator = {
              type = "and"
            }
            query = {
              params = ["A"]
            }
            reducer = {
              params = []
              type   = "last"
            }
            type = "query"
          }
        ]
        datasource = {
          type = "__expr__"
          uid  = "-100"
        }
        hide          = false
        intervalMs    = 1000
        maxDataPoints = 43200
        refId         = "B"
        type          = "classic_conditions"
      })
    }
  }
}
