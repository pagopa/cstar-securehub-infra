locals {
  trigger_pipelines = {
    for key, tmpl in local.pipeline_templates : key => key
  }

  parametrized_daily_pipeline = "idpay_copy_rdb_products_to_csv"

  daily_trigger_pipelines = {
    for k, v in local.trigger_pipelines : k => v
    if k != local.parametrized_daily_pipeline
  }

  daily_trigger_keys = sort(keys(local.daily_trigger_pipelines))

  daily_trigger_list = [
    for idx, key in local.daily_trigger_keys : {
      index = idx
      key   = key
    }
  ]
}

resource "azurerm_data_factory_trigger_schedule" "daily_triggers" {
  for_each = {
    for item in local.daily_trigger_list : item.key => item
  }

  name            = "trigger-${each.value.key}"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  activated       = true
  interval        = 1
  frequency       = "Day"

  start_time = "2025-10-08T08:12:00Z"
  time_zone  = "W. Europe Standard Time"

  pipeline {
    name = each.value.key
  }

  schedule {
    hours   = [floor((each.value.index * 10) / 60)]
    minutes = [each.value.index * 10 % 60]
  }

  depends_on = [azurerm_data_factory_pipeline.pipelines]
}



resource "azurerm_data_factory_trigger_schedule" "idpay_copy_rdb_products_to_csv_daily" {
  name            = "trigger-idpay_copy_rdb_products_to_csv"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  activated       = true
  interval        = 1
  frequency       = "Day"

  # Execution at 00:00 (Europe/Rome time)
  start_time = "2025-10-27T00:00:00Z"
  time_zone  = "W. Europe Standard Time"

  pipeline {
    name = local.parametrized_daily_pipeline
    parameters = {
      subscriptionId     = data.azurerm_subscription.current.subscription_id
      resourceGroup      = data.azurerm_resource_group.idpay_data_rg.name
      exportAccountName  = module.storage_idpay_exports.name
      notifyUrl          = local.notify_url
      kvUrl              = data.azurerm_key_vault.domain_kv.vault_uri
      kvSecretName       = "apim-idpay-email-export-subkey"
      notifyToSecretName = "idpay-export-email-mimit"
    }
  }

  schedule {
    hours   = [1]
    minutes = [0]
  }

  depends_on = [
    azurerm_data_factory_pipeline.pipelines,
    azurerm_role_assignment.adf_can_list_service_sas
  ]
}
