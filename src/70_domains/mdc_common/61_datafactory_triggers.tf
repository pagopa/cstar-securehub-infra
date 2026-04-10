locals {
  # Daily pipelines
  pipelines_daily = [
    "citizen_metrics_daily"
  ]

  pipelines_indexed = {
    for idx, name in local.pipelines_daily :
    name => idx
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
