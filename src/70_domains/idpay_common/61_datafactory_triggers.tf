locals {
  parametrized_daily_pipeline = "idpay_copy_rdb_products_to_csv"

  pipelines_T = [
    "idpay_merchant_copy",
    "idpay_merchant_counters_copy",
    "idpay_onboarding_citizen_copy",
    "idpay_pos_copy",
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

  # Multi-initiative export: map by key → initiative object and key → idx for schedule offset
  export_initiatives_indexed = {
    for idx, ini in var.export_initiatives : ini.key => ini
  }

  export_initiatives_idx = {
    for idx, ini in var.export_initiatives : ini.key => idx
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

# ─────────────────────────────────────────────────────────────────
# Multi-Initiative Export Triggers
# One set of 3 triggers per initiative declared in var.export_initiatives
# Schedule offset: CSV at 01:xx, Products at 02:xx, POS at 03:xx
# ─────────────────────────────────────────────────────────────────

resource "azurerm_data_factory_trigger_schedule" "export_csv_daily" {
  for_each = local.export_initiatives_indexed

  name            = "trigger-idpay_copy_rdb_products_to_csv-${each.key}"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  activated       = var.env_short == "p"
  interval        = 1
  frequency       = "Day"

  start_time = "2025-10-27T00:00:00Z"
  time_zone  = "W. Europe Standard Time"

  pipeline {
    name = "idpay_copy_rdb_products_to_csv"
    parameters = {
      initiativeId       = each.value.initiative_id
      initiativeFolder   = each.value.initiative_folder
      initiativeName     = each.value.initiative_name
      subscriptionId     = data.azurerm_subscription.current.subscription_id
      resourceGroup      = data.azurerm_resource_group.idpay_data_rg.name
      exportAccountName  = module.storage_idpay_exports.name
      notifyUrl          = local.notify_url
      kvUrl              = data.azurerm_key_vault.domain_kv.vault_uri
      kvSecretName       = each.value.kv_secret_subkey
      notifyToSecretName = each.value.kv_secret_email
    }
  }

  schedule {
    hours   = [1 + local.export_initiatives_idx[each.key]]
    minutes = [0]
  }

  depends_on = [
    azurerm_data_factory_pipeline.pipelines,
    azurerm_role_assignment.adf_can_list_service_sas
  ]
}

resource "azurerm_data_factory_trigger_schedule" "export_products_daily" {
  for_each = local.export_initiatives_indexed

  name            = "trigger-idpay_product_export_daily-${each.key}"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  activated       = var.env_short == "p"
  interval        = 1
  frequency       = "Day"

  start_time = "2025-10-27T00:00:00Z"
  time_zone  = "W. Europe Standard Time"

  pipeline {
    name = "idpay_product_export_daily"
    parameters = {
      initiativeId     = each.value.initiative_id
      initiativeFolder = each.value.initiative_folder
    }
  }

  schedule {
    hours   = [2 + local.export_initiatives_idx[each.key]]
    minutes = [0]
  }

  depends_on = [azurerm_data_factory_pipeline.pipelines]
}

resource "azurerm_data_factory_trigger_schedule" "export_pos_daily" {
  for_each = local.export_initiatives_indexed

  name            = "trigger-idpay_pos_export_daily-${each.key}"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  activated       = var.env_short == "p"
  interval        = 1
  frequency       = "Day"

  start_time = "2025-10-27T00:00:00Z"
  time_zone  = "W. Europe Standard Time"

  pipeline {
    name = "idpay_pos_export_daily"
    parameters = {
      initiativeId     = each.value.initiative_id
      initiativeFolder = each.value.initiative_folder
    }
  }

  schedule {
    hours   = [3 + local.export_initiatives_idx[each.key]]
    minutes = [0]
  }

  depends_on = [azurerm_data_factory_pipeline.pipelines]
}
