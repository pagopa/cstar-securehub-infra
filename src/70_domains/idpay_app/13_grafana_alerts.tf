locals {
  grafana_managed_name                 = "cstar-${var.env_short}-itn-grafana"
  grafana_managed_rg_name              = "cstar-${var.env_short}-itn-platform-monitoring-rg"
  core_kv_name                         = "${local.project_core}-kv"
  core_kv_rg_name                      = "${local.project_core}-sec-rg"
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

data "azurerm_key_vault" "core" {
  name                = local.core_kv_name
  resource_group_name = local.core_kv_rg_name
}

data "azurerm_key_vault_secret" "grafana_service_account_token" {
  name         = "grafana-itn-service-account-token-value"
  key_vault_id = data.azurerm_key_vault.core.id
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
  provider         = grafana.cloud
  count            = var.idpay_grafana_alert_enabled ? 1 : 0
  org_id           = 1
  name             = local.grafana_alert_rule_group_name
  folder_uid       = grafana_folder.idpay_app_alerts[0].uid
  interval_seconds = 60

  rule {
    name      = "reward-batch-transaction-mismatch-alert"
    condition = "C"

    data {
      ref_id     = "A"
      query_type = "KQL"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "grafana-azure-data-explorer-datasource"
      model          = "{\"OpenAI\":false,\"database\":\"idpay\",\"datasource\":{\"type\":\"grafana-azure-data-explorer-datasource\",\"uid\":\"grafana-azure-data-explorer-datasource\"},\"expression\":{\"groupBy\":{\"expressions\":[],\"type\":\"and\"},\"reduce\":{\"expressions\":[],\"type\":\"and\"},\"where\":{\"expressions\":[],\"type\":\"and\"}},\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"pluginVersion\":\"7.2.6\",\"query\":\"let TrxCountByBatch =\\ntransaction\\n| where isnotempty(rewardBatchId)\\n| summarize trx_count = count() by rewardBatchId;\\nrewards_batch\\n| extend batch_id = tostring(_id), expected_count = tolong(numberOfTransactions)\\n| join kind=leftouter TrxCountByBatch on $left.batch_id == $right.rewardBatchId\\n| extend trx_count = coalesce(trx_count, 0)\\n| where expected_count != trx_count\\n| count\",\"querySource\":\"raw\",\"queryType\":\"KQL\",\"rawMode\":true,\"refId\":\"A\",\"resultFormat\":\"table\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"B\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[10],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"B\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    annotations = {
      description = "mismatch alert is firing"
      summary     = "IDPay ADX Grafana alert"
    }
    is_paused = false

    notification_settings {
      contact_point = grafana_contact_point.idpay_app_alerts[0].name
    }
  }
}
