locals {
  idpay_kv_name                       = "${local.product_nodomain}-idpay-kv"
  idpay_kv_rg_name                    = "${local.product_nodomain}-idpay-security-rg"
  grafana_alert_folder_name           = "IDPay App Alerts"
  grafana_alert_contact_point_name    = "idpay-app-notifications"
  grafana_alert_rule_group_name       = "idpay-app-basic-alerts"
  grafana_mute_timing_name            = "working-hours"
  grafana_rule_group_interval_seconds = 60 * 60
}

data "grafana_data_source" "grafana-azure-data-explorer-datasource" {
  provider = grafana.cloud
  name     = "grafana-azure-data-explorer-datasource"
}

data "azurerm_key_vault" "key_vault_domain" {
  name                = local.idpay_kv_name
  resource_group_name = local.idpay_kv_rg_name
}

data "azurerm_key_vault_secret" "slack_webhook_url" {
  count        = var.idpay_grafana_alert_enabled ? 1 : 0
  name         = "slack-webhook-alert"
  key_vault_id = data.azurerm_key_vault.key_vault_domain.id
}

resource "grafana_folder" "idpay_app_alerts" {
  provider = grafana.cloud
  count    = var.idpay_grafana_alert_enabled ? 1 : 0

  title = local.grafana_alert_folder_name
}

data "grafana_folder" "idpay_app_alerts_existing" {
  provider = grafana.cloud
  count    = var.idpay_grafana_alert_enabled ? 1 : 0
  title    = local.grafana_alert_folder_name
}

import {
  to = grafana_folder.idpay_app_alerts[0]
  id = data.grafana_folder.idpay_app_alerts_existing[0].uid
}

resource "grafana_contact_point" "idpay_app_alerts" {
  provider = grafana.cloud
  count    = var.idpay_grafana_alert_enabled ? 1 : 0

  name = local.grafana_alert_contact_point_name

  slack {
    url   = data.azurerm_key_vault_secret.slack_webhook_url[0].value
    title = "[${var.env}] {{ template \"default.title\" . }}"
    text  = "{{ template \"default.message\" . }}"
  }
}

import {
  to = grafana_contact_point.idpay_app_alerts[0]
  id = local.grafana_alert_contact_point_name
}

resource "grafana_rule_group" "idpay_app_alerts" {
  provider         = grafana.cloud
  count            = var.idpay_grafana_alert_enabled ? 1 : 0
  name             = local.grafana_alert_rule_group_name
  folder_uid       = grafana_folder.idpay_app_alerts[0].uid
  interval_seconds = local.grafana_rule_group_interval_seconds

  rule {
    name            = "reward-batch-transaction-mismatch-alert"
    condition       = "C"
    for             = "0"
    keep_firing_for = "${local.grafana_rule_group_interval_seconds + (10 * 60)}s"

    data {
      ref_id     = "A"
      query_type = "KQL"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = data.grafana_data_source.grafana-azure-data-explorer-datasource.uid
      model          = "{\"OpenAI\":false,\"database\":\"idpay\",\"datasource\":{\"type\":\"grafana-azure-data-explorer-datasource\",\"uid\":\"${data.grafana_data_source.grafana-azure-data-explorer-datasource.uid}\"},\"expression\":{\"groupBy\":{\"expressions\":[],\"type\":\"and\"},\"reduce\":{\"expressions\":[],\"type\":\"and\"},\"where\":{\"expressions\":[],\"type\":\"and\"}},\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"pluginVersion\":\"7.2.6\",\"query\":\"let TrxCountByBatch =\\ntransaction\\n| where isnotempty(rewardBatchId)\\n| summarize trx_count = count() by rewardBatchId;\\nrewards_batch\\n| extend batch_id = tostring(_id), expected_count = tolong(numberOfTransactions)\\n| join kind=leftouter TrxCountByBatch on $left.batch_id == $right.rewardBatchId\\n| extend trx_count = coalesce(trx_count, 0)\\n| where expected_count != trx_count\\n| count\",\"querySource\":\"raw\",\"queryType\":\"KQL\",\"rawMode\":true,\"refId\":\"A\",\"resultFormat\":\"table\"}"
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
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"B\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
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

import {
  to = grafana_rule_group.idpay_app_alerts[0]
  id = "${data.grafana_folder.idpay_app_alerts_existing[0].uid}:${local.grafana_alert_rule_group_name}"
}

resource "grafana_notification_policy" "idpay_app_alerts" {
  provider = grafana.cloud
  count    = var.idpay_grafana_alert_enabled ? 1 : 0

  contact_point = "idpay-app-notifications"
  group_by      = ["grafana_folder", "alertname"]

  policy {
    contact_point   = "idpay-app-notifications"
    group_by        = ["..."]
    group_wait      = "0s"
    group_interval  = "1s"
    repeat_interval = "1d"

    matcher {
      label = "grafana_folder"
      match = "="
      value = "IDPay App Alerts"
    }

    active_timings = [local.grafana_mute_timing_name]
  }
}

resource "grafana_mute_timing" "idpay_app_alerts" {
  provider = grafana.cloud
  count    = var.idpay_grafana_alert_enabled ? 1 : 0

  name = local.grafana_mute_timing_name
  intervals {

    times {
      start = "09:00"
      end   = "18:00"
    }

    weekdays = ["monday", "tuesday", "wednesday", "thursday", "friday"]
    location = "Europe/Rome"
  }
}
