locals {
  # All pipelines
  trigger_pipelines = {
    for key, tmpl in local.pipeline_templates : key => key
  }

  # Pipeline only weekly
  weekly_pipelines = [
    "idpay_copy_rdb_products_to_csv"
  ]

  # Only Daily pipelines
  daily_trigger_pipelines = {
    for k, v in local.trigger_pipelines : k => v
    if !contains(local.weekly_pipelines, k)
  }

  # Weekly pipelines
  weekly_trigger_pipelines = {
    for k, v in local.trigger_pipelines : k => v
    if contains(local.weekly_pipelines, k)
  }
}



resource "azurerm_data_factory_trigger_schedule" "daily_triggers" {
  for_each        = local.daily_trigger_pipelines
  name            = "trigger-${each.key}"
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

  depends_on = [azurerm_data_factory_pipeline.pipelines]
}

resource "azurerm_data_factory_trigger_schedule" "weekly_triggers" {
  for_each        = local.weekly_trigger_pipelines
  name            = "trigger-weekly-${each.key}"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  activated       = true
  interval        = 1
  frequency       = "Week"

  start_time = "2025-10-27T02:00:00Z"
  time_zone  = "W. Europe Standard Time"

  pipeline {
      name = each.key
      parameters = {
        subscriptionId    = data.azurerm_subscription.current.subscription_id
        resourceGroup     = data.azurerm_resource_group.idpay_data_rg.name
        exportAccountName = module.storage_idpay_exports.name
        notifyTo          = local.notify_to
        notifyUrl         = local.notify_url
      }
    }
  schedule {
    days_of_week = ["Monday"]
    hours        = [2]
    minutes      = [0]
  }

  depends_on = [
    azurerm_data_factory_pipeline.pipelines,
    azurerm_role_assignment.adf_can_list_service_sas
  ]
}
