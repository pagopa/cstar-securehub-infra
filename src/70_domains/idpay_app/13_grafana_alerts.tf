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
    url   = data.azurerm_key_vault_secret.slack_webhook_url[0].value
    title = "{{ template \"default.title\" . }}"
    text  = "{{ template \"default.message\" . }}"
  }
}

resource "grafana_rule_group" "idpay_app_alerts" {
  provider = grafana.cloud
  count    = var.idpay_grafana_alert_enabled ? 1 : 0

  name             = local.grafana_alert_rule_group_name
  folder_uid       = grafana_folder.idpay_app_alerts[0].uid
  interval_seconds = 60

  rule {
    name           = "reward-batch-transaction-mismatch-alert"
    for            = "2m"
    condition      = "C"
    no_data_state  = "OK"
    exec_err_state = "Error"
    annotations = {
      description = "mismatch alert is firing"
      summary     = "IDPay ADX Grafana alert"
    }
    labels = {
      domain   = var.domain
      service  = "idpay-app"
      severity = "critical"
      source   = "terraform"
    }

    notification_settings {
      contact_point = grafana_contact_point.idpay_app_alerts[0].name
    }

    data {
      ref_id     = "A"
      query_type = "KQL"
      relative_time_range {
        from = 600
        to   = 0
      }
      datasource_uid = "af2bx3h1osn40b"
      model = jsonencode({
        "database"    = "idpay",
        "datasource"  = { "type" = "grafana-azure-data-explorer-datasource", "uid" = "af2bx3h1osn40b" },
        "query"       = "let TrxCountByBatch = transaction | where isnotempty(rewardBatchId) | summarize trx_count = count() by rewardBatchId; rewards_batch | extend batch_id = tostring(_id), expected_count = tolong(numberOfTransactions) | join kind=leftouter TrxCountByBatch on $left.batch_id == $right.rewardBatchId | extend trx_count = coalesce(trx_count, 0) | where expected_count != trx_count | count",
        "querySource" = "raw",
        "queryType"   = "KQL",
        "refId"       = "A"
      })
    }

    data {
      ref_id         = "B"
      datasource_uid = "__expr__"
      model = jsonencode({
        "conditions" = [{ "evaluator" = { "params" = [], "type" = "gt" }, "operator" = { "type" = "and" }, "query" = { "params" = [] }, "reducer" = { "params" = [], "type" = "last" }, "type" = "query" }],
        "expression" = "A",
        "refId"      = "B",
        "type"       = "reduce"
      })
    }

    data {
      ref_id         = "C"
      datasource_uid = "__expr__"
      model = jsonencode({
        "conditions" = [{ "evaluator" = { "params" = [10], "type" = "gt" }, "operator" = { "type" = "and" }, "query" = { "params" = [] }, "reducer" = { "params" = [], "type" = "last" }, "type" = "query" }],
        "expression" = "B",
        "refId"      = "C",
        "type"       = "threshold"
      })
    }

  }
}
