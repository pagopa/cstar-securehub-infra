locals {
  parametrized_daily_pipeline = "idpay_copy_rdb_products_to_csv"

  # Definizione iniziative per export automatici multi-iniziativa
  # Aggiungere qui tutte le iniziative da esportare giornalmente
  export_initiatives = {
    # Chiave: identificativo univoco
    # initiativeId: ID Cosmos della iniziativa
    # initiativeFolder: cartella di destinazione in $web blob
    # initiativeName: nome leggibile per notifiche email
    "bonuselettrodomestici" = {
      initiativeId     = "68dd003ccce8c534d1da22bc"
      initiativeFolder = "bonuselettrodomestici"
      initiativeName   = "Bonus Elettrodomestici"
    }
    "bonusdecoder" = {
      initiativeId     = "XXXXX"
      initiativeFolder = "bonusdecoder"
      initiativeName   = "Bonus Decoder"
    }
  }

  # Aggiungere una voce per ogni iniziativa con offset orario (minuti)
  export_initiatives_indexed = {
    for idx, key in keys(local.export_initiatives) :
    key => {
      data           = local.export_initiatives[key]
      offset_minutes = idx * 60 # 01:00, 02:00, 03:00, etc.
    }
  }

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





# Trigger multi-iniziativa per export prodotti CSV
# Ogni iniziativa ha un orario sfalsato per evitare parallelismo
resource "azurerm_data_factory_trigger_schedule" "export_products_csv_per_initiative" {
  for_each = local.export_initiatives_indexed

  name            = "trigger-idpay_copy_rdb_products_to_csv-${each.key}"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  activated       = var.env_short == "p"
  interval        = 1
  frequency       = "Day"

  # Base time: 00:00 UTC, poi offset per ogni iniziativa
  start_time = "2025-10-27T00:00:00Z"
  time_zone  = "W. Europe Standard Time"

  pipeline {
    name = local.parametrized_daily_pipeline
    parameters = {
      subscriptionId     = data.azurerm_subscription.current.subscription_id
      resourceGroup      = data.azurerm_resource_group.idpay_data_rg.name
      exportAccountName  = module.storage_idpay_exports.name
      initiativeId       = each.value.data.initiativeId
      initiativeFolder   = each.value.data.initiativeFolder
      initiativeName     = each.value.data.initiativeName
      notifyUrl          = local.notify_url
      kvUrl              = data.azurerm_key_vault.domain_kv.vault_uri
      kvSecretName       = "apim-idpay-email-export-subkey"
      notifyToSecretName = "idpay-export-email-mimit"
    }
  }

  schedule {
    hours   = [floor((each.value.offset_minutes / 60) + 1)]
    minutes = [each.value.offset_minutes % 60]
  }

  depends_on = [
    azurerm_data_factory_pipeline.pipelines,
    azurerm_role_assignment.adf_can_list_service_sas
  ]
}

# Trigger multi-iniziativa per export prodotti JSON
resource "azurerm_data_factory_trigger_schedule" "export_products_json_per_initiative" {
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
      initiativeId     = each.value.data.initiativeId
      initiativeFolder = each.value.data.initiativeFolder
    }
  }

  schedule {
    hours   = [floor((each.value.offset_minutes / 60) + 2)]
    minutes = [each.value.offset_minutes % 60]
  }

  depends_on = [azurerm_data_factory_pipeline.pipelines]
}

# Trigger multi-iniziativa per export POS JSON con join
resource "azurerm_data_factory_trigger_schedule" "export_pos_json_per_initiative" {
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
      initiativeId     = each.value.data.initiativeId
      initiativeFolder = each.value.data.initiativeFolder
    }
  }

  schedule {
    hours   = [floor((each.value.offset_minutes / 60) + 3)]
    minutes = [each.value.offset_minutes % 60]
  }

  depends_on = [azurerm_data_factory_pipeline.pipelines]
}
