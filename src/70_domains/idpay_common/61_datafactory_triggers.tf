locals {
  parametrized_daily_pipeline = "idpay_copy_rdb_products_to_csv"

  pipelines_T = [
    "idpay_merchant_copy",
    "idpay_merchant_counters_copy",
    "idpay_onboarding_citizen_copy",
    "idpay_pos_copy",
    "idpay_pos_export_daily",
    "idpay_product_export_daily",
    "idpay_reported_user_copy",
    "rdb_product_copy"
  ]

  pipelines_U = [
    "idpay_initiative_counters_copy",
    "idpay_rewards_batch_copy",
    "idpay_timeline_copy",
    "idpay_transaction_copy",
    "idpay_transaction_in_progress_copy",
    "idpay_wallet_copy"
  ]

  pipelines_weekly = [
    "idpay_data_vault_copy"
  ]


  pipelines_T_indexed = {
    for idx, name in local.pipelines_T :
    name => idx
  }
}

resource "azurerm_data_factory_trigger_schedule" "daily_triggers_T" {
  for_each = local.pipelines_T_indexed

  name            = "trigger-${each.key}"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  activated       = true
  frequency       = "Day"
  interval        = 1

  start_time = "2025-10-08T08:00:00Z"
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

resource "azurerm_data_factory_trigger_schedule" "daily_triggers_U" {
  for_each = toset(local.pipelines_U)

  name            = "trigger-${each.key}"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  activated       = true
  frequency       = "Day"
  interval        = 1

  start_time = "2025-10-08T08:00:00Z"
  time_zone  = "W. Europe Standard Time"

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
  for_each = toset(local.pipelines_weekly)

  name            = "trigger-${each.key}"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  activated       = true
  frequency       = "Week"
  interval        = 1

  start_time = "2025-10-08T08:00:00Z"
  time_zone  = "W. Europe Standard Time"

  schedule {
    days_of_week = ["Monday"]
    hours        = [0]
    minutes      = [0]
  }

  pipeline {
    name = each.key
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
