locals {
  # Daily pipelines — run on 00:xx
  pipelines_daily = [
    "mdc_citizen_metrics_daily",
    "mdc_tpp_daily",
  ]

  # Daily pipelines for logs reading — run after 00:00UTC (>= 02:00 CEST)
  pipelines_daily_logs = [
    "mdc_message_volume_daily",
    "mdc_retrieval_daily",
    "mdc_message_daily",
    "mdc_finalized_message_daily",
    "mdc_payment_attempt_daily"
  ]

  pipelines_indexed = {
    for idx, name in local.pipelines_daily : name => idx
  }

  pipelines_logs_indexed = {
    for idx, name in local.pipelines_daily_logs : name => idx
  }
}

resource "azurerm_data_factory_trigger_schedule" "daily_triggers" {
  for_each = local.pipelines_indexed

  name            = "trigger-${each.key}"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  activated       = true
  frequency       = "Day"
  interval        = 1

  start_time = "2026-04-10T08:00:00Z"
  time_zone  = "W. Europe Standard Time"

  pipeline {
    name = each.key
  }

  schedule {
    hours   = [floor((each.value * 10) / 60)]
    minutes = [(each.value * 10) % 60]
  }

  depends_on = [azurerm_data_factory_pipeline.pipelines]
}

resource "azurerm_data_factory_trigger_schedule" "daily_triggers_logs" {
  for_each = local.pipelines_logs_indexed

  name            = "trigger-${each.key}"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  activated       = true
  frequency       = "Day"
  interval        = 1
  start_time      = "2026-04-10T08:00:00Z"
  time_zone       = "W. Europe Standard Time"

  pipeline {
    name = each.key
  }

  schedule {
    hours   = [2 + floor((each.value * 10) / 60)]
    minutes = [(each.value * 10) % 60]
  }

  depends_on = [azurerm_data_factory_pipeline.pipelines]
}
