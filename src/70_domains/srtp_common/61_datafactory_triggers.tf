locals {
  # Daily pipelines — run at 08:00 Europe/Rome local time
  pipelines_daily_logs = [
    "srtp_activation_success_rate_daily",
    "srtp_in_channel_settlement_rate_daily",
    "srtp_user_refusal_rate_daily",
    "srtp_taxonomy_eligibility_rate_daily",
    "srtp_active_payer_reachability_daily"
  ]

  pipelines_logs_indexed = {
    for idx, name in local.pipelines_daily_logs : name => idx
  }
}

resource "azurerm_data_factory_trigger_schedule" "daily_triggers_logs" {
  for_each = var.env_short == "p" ? local.pipelines_logs_indexed : {}

  name            = "trigger-${each.key}"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  activated       = true
  frequency       = "Day"
  interval        = 1
  start_time      = "2026-08-24T08:00:00Z"
  time_zone       = "W. Europe Standard Time"

  pipeline {
    name = each.key
  }

  schedule {
    hours   = [8 + floor((each.value * 10) / 60)]
    minutes = [(each.value * 10) % 60]
  }

  depends_on = [azurerm_data_factory_pipeline.pipelines]
}
