# ------------------------------------------------------------------------------
# CosmosDB MongoDB databases and collections
# ------------------------------------------------------------------------------
locals {
  collections_idpay_beneficiari = [
    {
      name                = "onboarding_citizen"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["updateDate"], unique = false },
        { keys = ["initiativeId"], unique = false },
        { keys = ["userId"], unique = false }
      ]
    },
    {
      name                = "onboarding_ranking_requests"
      shard_key           = "_id"
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
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["rankingEndDate"], unique = false }
      ]
    },
    {
      name                = "onboarding_families"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["memberIds"], unique = false },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "mocked_families"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["memberIds"], unique = false }
      ]
    },
    {
      name                = "mocked_isee"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "hpan_initiatives_lookup"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["onboardedInitiatives.initiativeId"], unique = false },
        { keys = ["userId"], unique = false },
        { keys = ["onboardedInitiatives"], unique = false }
      ]
    },
    {
      name                = "payment_instrument"
      shard_key           = "_id"
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
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "group"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "group_user_whitelist"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["groupId"], unique = false },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "iban"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["userId"], unique = false }
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
    },
    {
      name                = "timeline"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId", "userId", "operationDate"], unique = false },
        { keys = ["eventId"], unique = false },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "notification"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["notificationStatus"], unique = false },
        { keys = ["retry"], unique = false },
        { keys = ["retryDate"], unique = false },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "anpr_info"
      shard_key           = "userId"
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
      name                = "custom_sequence"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "self_declaration_text"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId", "userId"], unique = false },
        { keys = ["userId"], unique = false },
        { keys = ["initiativeId"], unique = false }
      ]
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
    }
  ]

  collections_idpay_pagamenti = [
    {
      name                = "transaction"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["idTrxIssuer"], unique = false },
        { keys = ["userId"], unique = false },
        { keys = ["trxDate"], unique = false },
        { keys = ["merchantId"], unique = false },
        { keys = ["elaborationDateTime"], unique = false },
        { keys = ["initiatives"], unique = false },
        { keys = ["status"], unique = false },
        { keys = ["additionalProperties.productName"], unique = false }
      ]
    },
    {
      name                = "transactions_processed"
      shard_key           = "_id"
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
      name                = "transaction_in_progress"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["trxCode"], unique = false },
        { keys = ["trxDate"], unique = false },
        { keys = ["updateDate"], unique = false },
        { keys = ["merchantId"], unique = false },
        { keys = ["status"], unique = false },
        { keys = ["initiativeId"], unique = false },
        { keys = ["userId"], unique = false },
        { keys = ["additionalProperties.productName"], unique = false }
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
      name                = "reward_notification_rule"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "rewards_iban"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "rewards"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["userId"], unique = false },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "rewards_notification"
      shard_key           = "_id"
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
      shard_key           = "_id"
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
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId"], unique = false },
        { keys = ["organizationId"], unique = false },
        { keys = ["feedbackDate"], unique = false }
      ]
    },
    {
      name                = "merchant_file"
      shard_key           = "fileName"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["fileName", "initiativeId"], unique = true },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "merchant"
      shard_key           = "fiscalCode"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["fiscalCode", "acquirerId"], unique = true },
        { keys = ["initiativeList.initiativeId"], unique = false },
        { keys = ["fiscalCode"], unique = false },
        { keys = ["acquirerId"], unique = false }
      ]
    },
    {
      name                = "merchant_initiative_counters"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId"], unique = false }
      ]
    },
    {
      name                = "point_of_sales"
      shard_key           = "contactEmail"
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
      name                = "expense_data"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["userId", "entityId"], unique = false },
        { keys = ["userId"], unique = false },
        { keys = ["entityId"], unique = false }
      ]
    },
    {
      name                = "rewards_suspended_users"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["initiativeId"], unique = false }
      ]
    }
  ]

  collections_idpay_iniziative = [
    {
      name                = "initiative"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "beneficiary_rule"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "initiative_counters"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "initiative_statistics"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "reward_rule"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "role_permission"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "portal_consent"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "config_mcc"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "config_trx_rule"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    }
  ]

  collections_rdb_shared = [
    {
      name                = "role_permission"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "portal_consent"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes             = [{ keys = ["_id"], unique = true }]
    },
    {
      name                = "product_file"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["dateUpload"], unique = false }
      ]
    },
    {
      name                = "product"
      shard_key           = "_id"
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["registrationDate"], unique = false },
        { keys = ["category"], unique = false },
        { keys = ["energyClass"], unique = false },
        { keys = ["eprelCode"], unique = false },
        { keys = ["status"], unique = false },
        { keys = ["productName"], unique = false },
        { keys = ["brand"], unique = false },
        { keys = ["model"], unique = false },
        { keys = ["organizationName"], unique = false },
        { keys = ["category", "productFileId"], unique = false }
      ]
    }
  ]

  plan_idpay_beneficiari = {
    for coll in local.collections_idpay_beneficiari :
    "idpay-beneficiari.${coll.name}" => merge(coll, { database_name = "idpay-beneficiari" })
  }

  plan_idpay_pagamenti = {
    for coll in local.collections_idpay_pagamenti :
    "idpay-pagamenti.${coll.name}" => merge(coll, { database_name = "idpay-pagamenti" })
  }

  plan_idpay_iniziative = {
    for coll in local.collections_idpay_iniziative :
    "idpay-iniziative.${coll.name}" => merge(coll, { database_name = "idpay-iniziative" })
  }

  plan_rdb_shared = {
    for coll in local.collections_rdb_shared :
    "rdb.${coll.name}" => merge(coll, { database_name = "rdb" })
  }

  collections_plan = merge(
    local.plan_idpay_beneficiari,
    local.plan_idpay_pagamenti,
    local.plan_idpay_iniziative,
    # local.plan_rdb_shared,
  )
}

# ------------------------------------------------------------------------------
# Databases
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_database" "databases" {
  for_each = toset([
    "idpay-beneficiari",
    "idpay-pagamenti",
    "idpay-iniziative",
    "rdb",
  ])

  name                = each.key
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  account_name        = module.cosmos_db_account.name

  throughput = null

  autoscale_settings {
    max_throughput = 1000
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

  shard_key           = each.value.shard_key
  default_ttl_seconds = each.value.default_ttl_seconds
  indexes             = each.value.indexes
  throughput          = null
  max_throughput      = null
}
