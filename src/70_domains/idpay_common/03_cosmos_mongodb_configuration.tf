
# Collections
locals {

  ###
  ### Collection IDPAY
  ###
  collections_idpay = [
    {
      name = "onboarding_citizen"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["updateDate"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        },
        {
          keys   = ["userId"]
          unique = false
        }
      ]
    },
    {
      name = "iban"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["userId"]
          unique = false
        }
      ]
    },
    {
      name = "payment_instrument"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId"]
          unique = false
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["status"]
          unique = false
        },
        {
          keys   = ["hpan"]
          unique = false
        }
      ]
    },
    {
      name = "notification"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["notificationStatus"]
          unique = false
        },
        {
          keys   = ["retry"]
          unique = false
        },
        {
          keys   = ["retryDate"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "wallet"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId", "userId"]
          unique = true
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["familyId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "timeline"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId", "userId", "operationDate"]
          unique = false
        },
        {
          keys   = ["eventId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "initiative"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "transaction"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["idTrxIssuer"]
          unique = false
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["trxDate"]
          unique = false
        },
        {
          keys   = ["merchantId"]
          unique = false
        },
        {
          keys   = ["elaborationDateTime"]
          unique = false
        },
        {
          keys   = ["initiatives"]
          unique = false
        }
      ]
    },
    {
      name = "reward_rule"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "beneficiary_rule"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "hpan_initiatives_lookup"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["onboardedInitiatives.initiativeId"]
          unique = false
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["onboardedInitiatives"],
          unique = false
        }
      ]
    },
    {
      name = "user_initiative_counters"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["entityId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        },
        {
          keys   = ["pendingTrx.id"]
          unique = false
        }
      ]
    },
    {
      name = "role_permission"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "portal_consent"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "initiative_counters"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "transactions_processed"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }, {
        keys   = ["userId"]
        unique = false
        }, {
        keys   = ["correlationId"]
        unique = false
        }, {
        keys   = ["acquirerId"]
        unique = false
        }, {
        keys   = ["initiatives"]
        unique = false
        }
      ]
    },
    {
      name = "group"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "config_mcc"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "config_trx_rule"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "reward_notification_rule"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "rewards_iban"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "rewards"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "rewards_notification"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["beneficiaryId"]
          unique = false
        },
        {
          keys   = ["externalId"]
          unique = false
        },
        {
          keys   = ["exportId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        },
        {
          keys   = ["notificationDate"]
          unique = false
        },
        {
          keys   = ["status"]
          unique = false
        },
        {
          keys   = ["cro"]
          unique = false
        }
      ]
    },
    {
      name = "rewards_organization_exports"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId"]
          unique = false
        },
        {
          keys   = ["organizationId"]
          unique = false
        },
        {
          keys   = ["notificationDate"]
          unique = false
        },
        {
          keys   = ["exportDate"]
          unique = false
        },
        {
          keys   = ["status"]
          unique = false
        }
      ]
    },
    {
      name = "initiative_statistics"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "rewards_organization_imports"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId"]
          unique = false
        },
        {
          keys   = ["organizationId"]
          unique = false
        },
        {
          keys   = ["feedbackDate"]
          unique = false
        }
      ]
    },
    {
      name = "onboarding_ranking_requests"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId", "rankingValue", "criteriaConsensusTimestamp"]
          unique = false
        },
        # descending order not supported, index manually created
        # https://pagopa.atlassian.net/browse/IDP-661
        #        {
        #          keys   = ["initiativeId", "rankingValue:-1", "criteriaConsensusTimestamp"]
        #          unique = false
        #        },
        {
          keys   = ["initiativeId", "rank"]
          unique = false
        },
        {
          keys   = ["organizationId"]
          unique = false
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "onboarding_ranking_rule"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["rankingEndDate"]
          unique = false
        },
      ]
    },
    {
      name = "group_user_whitelist"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["groupId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        },
      ]
    },
    {
      name = "custom_sequence"
      indexes = [{
        keys   = ["_id"]
        unique = true
      }]
    },
    {
      name = "rewards_suspended_users"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "transaction_in_progress"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }, {
        keys   = ["trxCode"]
        unique = false
        }, {
        keys   = ["trxDate"]
        unique = false
        }, {
        keys   = ["updateDate"]
        unique = false
        }, {
        keys   = ["merchantId"]
        unique = false
        }, {
        keys   = ["status"]
        unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        },
        {
          keys   = ["userId"]
          unique = false
        },
      ]
    },
    {
      name = "onboarding_families"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }, {
        keys   = ["memberIds"]
        unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "mocked_families"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }, {
        keys   = ["memberIds"]
        unique = false
        }
      ]
    },
    {
      name = "mocked_isee"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "merchant_file"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["fileName", "initiativeId"]
          unique = true
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "merchant"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["fiscalCode", "acquirerId"]
          unique = true
        },
        {
          keys   = ["initiativeList.initiativeId"]
          unique = false
        },
        {
          keys   = ["fiscalCode"]
          unique = false
        },
        {
          keys   = ["acquirerId"]
          unique = false
        }
      ]
    },
    {
      name = "merchant_initiative_counters"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "payment_instrument_code"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "anpr_info"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId", "userId"]
          unique = true
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["familyId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "self_declaration_text"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId", "userId"]
          unique = false
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "expense_data"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["userId", "entityId"]
          unique = false
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["entityId"]
          unique = false
        }
      ]
    },
    {
      name = "point_of_sales"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["franchiseName"]
          unique = false
        },
        {
          keys   = ["type"]
          unique = false
        },
        {
          keys   = ["address", "streetNumber"]
          unique = false
        },
        {
          keys   = ["website"]
          unique = false
        },
        {
          keys   = ["city"]
          unique = false
        },
        {
          keys   = ["contactEmail"]
          unique = true
        },
        {
          keys   = ["contactName", "contactSurname"]
          unique = false
        }
      ]
    }
  ]
  ###
  ### Collection RDB
  ###
  collections_rdb = [
    {
      name = "role_permission"
      indexes = [
        {
          keys   = ["_id"]
          unique = true
        }
      ]
    },
    {
      name = "portal_consent"
      indexes = [
        {
          keys   = ["_id"]
          unique = true
        }
      ]
    },
    {
      name = "product_file"
      indexes = [
        {
          keys   = ["_id"]
          unique = true
        },
        {
          keys   = ["dateUpload"]
          unique = false
        }
      ]
    },
    {
      name = "product"
      indexes = [
        {
          keys   = ["_id"]
          unique = true
        },
        {
          keys   = ["registrationDate"]
          unique = false
        },
        {
          keys   = ["category"]
          unique = false
        },
        {
          keys   = ["energyClass"]
          unique = false
        },
        {
          keys   = ["eprelCode"]
          unique = false
        },
        {
          keys   = ["status"]
          unique = false
        },
        {
          keys   = ["productName"]
          unique = false
        },
        {
          keys   = ["category", "productFileId"]
          unique = false
        }
      ]
    }
  ]
}

#
# Database idpay
#
resource "azurerm_cosmosdb_mongo_database" "idpay" {
  name                = "idpay"
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  account_name        = module.cosmos_db_account.name

  throughput = var.cosmos_mongo_db_idpay_params.throughput

  dynamic "autoscale_settings" {
    for_each = var.cosmos_mongo_db_idpay_params.max_throughput != null ? [""] : []
    content {
      max_throughput = var.cosmos_mongo_db_idpay_params.max_throughput
    }
  }

  lifecycle {
    ignore_changes = [
      autoscale_settings
    ]
  }
}

#
# Database rdb
#

resource "azurerm_cosmosdb_mongo_database" "rdb" {
  name                = "rdb"
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  account_name        = module.cosmos_db_account.name

  throughput = var.cosmos_mongo_db_idpay_params.throughput

  dynamic "autoscale_settings" {
    for_each = var.cosmos_mongo_db_idpay_params.max_throughput != null ? [""] : []
    content {
      max_throughput = var.cosmos_mongo_db_idpay_params.max_throughput
    }
  }

  lifecycle {
    ignore_changes = [
      autoscale_settings
    ]
  }
}

#
# Collection idpay
#
resource "azurerm_cosmosdb_mongo_collection" "mongodb_collections_idpay" {
  for_each = {
    for index, coll in local.collections_idpay :
    coll.name => coll
  }

  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name

  account_name  = module.cosmos_db_account.name
  database_name = azurerm_cosmosdb_mongo_database.idpay.name

  dynamic "index" {
    for_each = each.value.indexes
    iterator = index
    content {
      keys   = index.value.keys
      unique = index.value.unique
    }
  }
  dynamic "autoscale_settings" {
    for_each = var.cosmos_mongo_db_idpay_params.max_throughput == null ? [] : ["dummy"]
    content {
      max_throughput = var.cosmos_mongo_db_idpay_params.max_throughput
    }
  }

  lifecycle {
    ignore_changes = [
      # ignore changes to autoscale_settings due to this operation is done manually
      autoscale_settings,
    ]
  }

  timeouts {
  }

}

#
# Collection rdb
#

resource "azurerm_cosmosdb_mongo_collection" "mongodb_collections_rdb" {

  for_each = {
    for index, coll in local.collections_rdb :
    coll.name => coll
  }

  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name

  account_name  = module.cosmos_db_account.name
  database_name = azurerm_cosmosdb_mongo_database.rdb.name

  dynamic "index" {
    for_each = each.value.indexes
    iterator = index
    content {
      keys   = index.value.keys
      unique = index.value.unique
    }
  }

  dynamic "autoscale_settings" {
    for_each = var.cosmos_mongo_db_idpay_params.max_throughput == null ? [] : ["dummy"]
    content {
      max_throughput = var.cosmos_mongo_db_idpay_params.max_throughput
    }
  }

  lifecycle {
    ignore_changes = [
      # ignore changes to autoscale_settings due to this operation is done manually
      autoscale_settings,
    ]
  }

  timeouts {
  }
}
