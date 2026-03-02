locals {
  collections = [
    {
      name = "citizen_consents"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["fiscalCode"]
          unique = true
        },
        {
          keys   = ["consents.$**"]
          unique = false
        }
      ]
    },
    {
      name = "tpp"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["tppId", "entityId"]
          unique = true
        },
        {
          keys   = ["tppId"]
          unique = true
        },
        {
          keys   = ["entityId"]
          unique = true
        }
      ]

    },
    {
      name = "message"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["entityId"]
          unique = false
        },
        {
          keys   = ["recipientId"]
          unique = false
        },
        {
          keys   = ["messageId", "entityId"]
          unique = true
        },
        {
          keys   = ["originId"]
          unique = false
        }
      ]

    },
    {
      name = "retrieval"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["retrievalId"]
          unique = true
        }
      ]
    },
    {
      name = "payment_attempt"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["tppId", "originId", "fiscalCode"]
          unique = true
        },
        {
          keys   = ["tppId"]
          unique = false
        },
        {
          keys   = ["originId"]
          unique = false
        },
        {
          keys   = ["fiscalCode"]
          unique = false
        }
      ]
    }
  ]
}

#-----------------------------------------------------------------------------------------------------------------------
# CosmosDB DB
#-----------------------------------------------------------------------------------------------------------------------

resource "azurerm_cosmosdb_mongo_database" "mongo_db" {
  name                = var.enable_cosmos_db_weu ? "mil" : var.domain
  resource_group_name = var.enable_cosmos_db_weu ? azurerm_resource_group.cosmosdb_mil_rg[0].name : data.azurerm_resource_group.mdc_data_rg.name
  account_name        = var.enable_cosmos_db_weu ? module.cosmosdb_account_mongodb_weu[0].name : module.cosmos_account[0].name

  dynamic "autoscale_settings" {
    for_each = var.cosmos_mongodb_common_configuration.autoscale_enabled ? [1] : []
    content {
      max_throughput = var.cosmos_mongodb_common_configuration.max_throughput
    }
  }
}

#-----------------------------------------------------------------------------------------------------------------------
# CosmosDB Collections
#-----------------------------------------------------------------------------------------------------------------------
module "cosmosdb_collections" {
  source   = "./.terraform/modules/__v4__/cosmosdb_mongodb_collection"
  for_each = { for index, coll in local.collections : coll.name => coll }

  name                = each.value.name
  resource_group_name = var.enable_cosmos_db_weu ? azurerm_resource_group.cosmosdb_mil_rg[0].name : data.azurerm_resource_group.mdc_data_rg.name

  cosmosdb_mongo_account_name  = var.enable_cosmos_db_weu ? module.cosmosdb_account_mongodb_weu[0].name : module.cosmos_account[0].name
  cosmosdb_mongo_database_name = azurerm_cosmosdb_mongo_database.mongo_db.name

  indexes     = each.value.indexes
  lock_enable = var.env_short == "p"

  default_ttl_seconds = each.value.name == "retrieval" ? 1800 : null
}

#-----------------------------------------------------------------------------------------------------------------------
# KV
#-----------------------------------------------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "cosmosdb_account_mongodb_connection_strings" {
  name         = "mongodb-connection-string"
  value        = var.enable_cosmos_db_weu ? module.cosmosdb_account_mongodb_weu[0].primary_connection_strings : module.cosmos_account[0].primary_connection_strings
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_domain.id

  tags = module.tag_config.tags
}

#-----------------------------------------------------------------------------------------------------------------------
# Alerts
#-----------------------------------------------------------------------------------------------------------------------
resource "azurerm_monitor_metric_alert" "cosmos_db_normalized_ru_exceeded" {
  count = var.env_short == "p" ? 1 : 0

  name                = "[${var.domain != null ? "${var.domain} | " : ""}${var.enable_cosmos_db_weu ? module.cosmosdb_account_mongodb_weu[0].name : module.cosmos_account[0].name}] Normalized RU Exceeded"
  resource_group_name = data.azurerm_resource_group.mdc_data_rg.name
  scopes              = [var.enable_cosmos_db_weu ? module.cosmosdb_account_mongodb_weu[0].id : module.cosmos_account[0].id]
  description         = "A collection Normalized RU/s exceed provisioned throughput, and it's raising latency. Please, consider to increase RU."
  severity            = 0
  window_size         = "PT5M"
  frequency           = "PT5M"
  auto_mitigate       = false

  criteria {
    metric_namespace       = "Microsoft.DocumentDB/databaseAccounts"
    metric_name            = "NormalizedRUConsumption"
    aggregation            = "Maximum"
    operator               = "GreaterThan"
    threshold              = "80"
    skip_metric_validation = false

    dimension {
      name     = "Region"
      operator = "Include"
      values   = [var.enable_cosmos_db_weu ? azurerm_resource_group.cosmosdb_mil_rg[0].location : data.azurerm_resource_group.mdc_data_rg.location]
    }

    dimension {
      name     = "CollectionName"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = data.azurerm_monitor_action_group.email.id
  }

  action {
    action_group_id = data.azurerm_monitor_action_group.slack.id
  }

  tags = merge(
    module.tag_config.tags,
    {
      "grafana" = "yes"
    }
  )
}
