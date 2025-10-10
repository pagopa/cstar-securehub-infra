locals {
  trigger_pipelines = {
    for key, tmpl in local.pipeline_templates :
    key => key
  }
}

resource "azurerm_data_factory_trigger_schedule" "daily_triggers" {
  for_each        = local.trigger_pipelines
  name            = "Trigger-${each.key}"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  activated       = true
  interval        = 1
  frequency       = "Day"
  start_time      = "2025-10-08T08:12:00Z"
  time_zone       = "W. Europe Standard Time"

  pipeline {
    name = each.key
  }

  schedule {
    hours   = [0]
    minutes = [0]
  }

  depends_on = [
    azurerm_data_factory_pipeline.pipelines
  ]
}
