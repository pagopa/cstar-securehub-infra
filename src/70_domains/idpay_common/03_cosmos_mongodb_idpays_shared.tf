# ------------------------------------------------------------------------------
# CosmosDB MongoDB databases and collections
# ------------------------------------------------------------------------------
locals {

  idpay_beneficiari_collections = [
    {
      name                = "anpr_info"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["userId", "initiativeId"], unique = true },
        { keys = ["userId"], unique = false },
        { keys = ["familyId"], unique = false },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "beneficiary_rule"
      shard_key           = null
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "custom_sequence"
      shard_key           = null
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "data_vault"
      shard_key           = "page"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["page", "_id"], unique = true },
        { keys = ["page", "data"], unique = true },
      ]
    },
    {
      name                = "group"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "group_user_whitelist"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["groupId"], unique = false },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "hpan_initiatives_lookup"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["onboardedInitiatives.initiativeId"], unique = false },
        { keys = ["userId"], unique = false },
        { keys = ["onboardedInitiatives"], unique = false }
      ]
    },
    {
      name                = "iban"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["userId"], unique = false }
      ]
    },
    {
      name                = "initiative_counters"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["userId"], unique = false },
        { keys = ["status"], unique = false }
      ]
    },
    {
      name                = "mocked_families"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["memberIds"], unique = false }
      ]
    },
    {
      name                = "mocked_isee"
      shard_key           = null
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "notification"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["notificationStatus", "retry", "retryDate"], unique = false },
        { keys = ["notificationStatus"], unique = false },
        { keys = ["retry"], unique = false },
        { keys = ["retryDate"], unique = false },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "onboarding_citizen"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["updateDate"], unique = false },
        { keys = ["initiativeId", "familyId"], unique = false },
        { keys = ["userId"], unique = false },
      ]
    },
    {
      name                = "onboarding_families"
      shard_key           = null
      default_ttl_seconds = 3600
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["memberIds"], unique = false },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "onboarding_ranking_requests"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId", "rankingValue", "criteriaConsensusTimestamp"], unique = false },
        { keys = ["initiativeId", "rank"], unique = false },
        { keys = ["organizationId"], unique = false },
        { keys = ["userId"], unique = false },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "onboarding_ranking_rule"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["rankingEndDate"], unique = false }
      ]
    },
    {
      name                = "payment_instrument"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId"], unique = false },
        { keys = ["userId"], unique = false },
        { keys = ["status"], unique = false },
        { keys = ["hpan"], unique = false }
      ]
    },
    {
      name                = "payment_instrument_code"
      shard_key           = null
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "reward_rule"
      shard_key           = null
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "self_declaration_text"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId", "userId"], unique = false },
        { keys = ["userId"], unique = false },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "timeline"
      shard_key           = "userId"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId", "userId", "operationDate"], unique = false },
        { keys = ["eventId"], unique = false },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "transaction_in_progress"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["_id", "trxCode"], unique = true },
        { keys = ["trxDate"], unique = false },
        { keys = ["trxChargeDate"], unique = false },
        { keys = ["updateDate"], unique = false },
        { keys = ["merchantId"], unique = false },
        { keys = ["status"], unique = false },
        { keys = ["initiativeId"], unique = false },
        { keys = ["userId"], unique = false },
        { keys = ["additionalProperties.productName"], unique = false }
      ]
    },
    {
      name                = "wallet"
      shard_key           = "userId"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["userId", "initiativeId"], unique = true },
        { keys = ["userId"], unique = false },
        { keys = ["familyId"], unique = false },
        { keys = ["initiativeId"], unique = false }
      ]
    }
  ]

  idpay_pagamenti_collections = [
    {
      name                = "expense_data"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["userId", "entityId"], unique = false },
        { keys = ["userId"], unique = false },
        { keys = ["entityId"], unique = false }
      ]
    },
    {
      name                = "merchant"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["fiscalCode", "acquirerId"], unique = true },
        { keys = ["initiativeList.initiativeId"], unique = false },
        { keys = ["fiscalCode"], unique = false },
        { keys = ["acquirerId"], unique = false },
        { keys = ["businessName"], unique = false }
      ]
    },
    {
      name                = "merchant_file"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["fileName", "initiativeId"], unique = true },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "point_of_sales"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["franchiseName"], unique = false },
        { keys = ["type"], unique = false },
        { keys = ["address"], unique = false },
        { keys = ["website"], unique = false },
        { keys = ["city"], unique = false },
        { keys = ["contactEmail"], unique = true },
        { keys = ["contactName", "contactSurname"], unique = false }
      ]
    },
    {
      name                = "reward_notification_rule"
      shard_key           = null
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "rewards"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["userId"], unique = false },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "rewards_batch"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["merchantId"], unique = false },
        { keys = ["month"], unique = false },
        { keys = ["name"], unique = false },
        { keys = ["posType"], unique = false },
        { keys = ["merchantId", "posType", "month"], unique = true },
        { keys = ["merchantSendDate"], unique = false }
      ]
    },
    {
      name                = "rewards_iban"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "rewards_notification"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["beneficiaryId"], unique = false },
        { keys = ["externalId"], unique = false },
        { keys = ["exportId"], unique = false },
        { keys = ["initiativeId"], unique = false },
        { keys = ["notificationDate"], unique = false },
        { keys = ["status"], unique = false },
        { keys = ["cro"], unique = false }
      ]
    },
    {
      name                = "rewards_organization_exports"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId"], unique = false },
        { keys = ["organizationId"], unique = false },
        { keys = ["notificationDate"], unique = false },
        { keys = ["exportDate"], unique = false },
        { keys = ["status"], unique = false }
      ]
    },
    {
      name                = "rewards_organization_imports"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId"], unique = false },
        { keys = ["organizationId"], unique = false },
        { keys = ["feedbackDate"], unique = false }
      ]
    },
    {
      name                = "rewards_suspended_users"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "transaction"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["idTrxIssuer"], unique = false },
        { keys = ["userId"], unique = false },
        { keys = ["trxDate"], unique = false },
        { keys = ["trxChargeDate"], unique = false },
        { keys = ["merchantId"], unique = false },
        { keys = ["elaborationDateTime"], unique = false },
        { keys = ["initiatives"], unique = false },
        { keys = ["status"], unique = false },
        { keys = ["additionalProperties.productName"], unique = false },
        { keys = ["rewardBatchId", "samplingKey"], unique = false },
        { keys = ["rewardBatchTrxStatus"], unique = false },
        { keys = ["rewardBatchId, pointOfSaleId, franchiseName"], unique = false }
      ]
    },
    {
      name                = "transactions_processed"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["userId"], unique = false },
        { keys = ["correlationId"], unique = false },
        { keys = ["acquirerId"], unique = false },
        { keys = ["initiatives"], unique = false }
      ]
    },
    {
      name                = "user_initiative_counters"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["entityId"], unique = false },
        { keys = ["initiativeId"], unique = false },
        { keys = ["pendingTrx.id"], unique = false }
      ]
    },
    {
      name                = "reports"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId", "merchantId"], unique = false }
      ]
    }
  ]

  idpay_iniziative_collections = [
    {
      name                = "config_mcc"
      shard_key           = null
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "config_trx_rule"
      shard_key           = null
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "initiative"
      shard_key           = null
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "initiative_statistics"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true }
      ]
    },
    {
      name                = "merchant_initiative_counters"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "portal_consent"
      shard_key           = null
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "role_permission"
      shard_key           = null
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    }
  ]

  # Le restanti definizioni rimangono invariate
  plan_idpay_beneficiari = {
    for coll in local.idpay_beneficiari_collections :
    "idpay-beneficiari.${coll.name}" => merge(coll, { database_name = "idpay-beneficiari" })
  }

  plan_idpay_pagamenti = {
    for coll in local.idpay_pagamenti_collections :
    "idpay-pagamenti.${coll.name}" => merge(coll, { database_name = "idpay-pagamenti" })
  }

  plan_idpay_iniziative = {
    for coll in local.idpay_iniziative_collections :
    "idpay-iniziative.${coll.name}" => merge(coll, { database_name = "idpay-iniziative" })
  }

  collections_plan = merge(
    local.plan_idpay_beneficiari,
    local.plan_idpay_pagamenti,
    local.plan_idpay_iniziative,
  )
}


# ------------------------------------------------------------------------------
# Databases
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_database" "databases" {
  for_each = toset([
    "idpay-beneficiari",
    "idpay-iniziative",
    "idpay-pagamenti",
  ])

  name                = each.key
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  account_name        = module.cosmos_db_account.name

  throughput = null

  dynamic "autoscale_settings" {
    for_each = var.env == "dev" ? [] : [1]
    content {
      max_throughput = 1000
    }
  }

  lifecycle {
    ignore_changes = [
      autoscale_settings,
      throughput
    ]
  }
}

# ------------------------------------------------------------------------------
# Collections
# ------------------------------------------------------------------------------
module "cosmos_mongodb_collections" {
  for_each = local.collections_plan

  source = "./.terraform/modules/__v4__/cosmosdb_mongodb_collection"

  name                         = each.value.name
  resource_group_name          = data.azurerm_resource_group.idpay_data_rg.name
  cosmosdb_mongo_account_name  = module.cosmos_db_account.name
  cosmosdb_mongo_database_name = azurerm_cosmosdb_mongo_database.databases[each.value.database_name].name

  shard_key           = each.value.shard_key != null ? each.value.shard_key : null
  default_ttl_seconds = each.value.default_ttl_seconds
  indexes             = each.value.indexes
  throughput          = null
  max_throughput      = null
}
