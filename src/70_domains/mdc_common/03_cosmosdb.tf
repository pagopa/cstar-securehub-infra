module "cosmos_account" {
  source = "./.terraform/modules/__v4__/IDH/cosmosdb_account"

  # General
  product_name        = var.prefix
  env                 = var.env
  location            = var.location
  resource_group_name = data.azurerm_resource_group.mdc_data_rg.name
  tags = merge(
    module.tag_config.tags,
    {
      "grafana" = "yes"
    }
  )

  # IDH Resources
  idh_resource_tier = "cosmos_mongo7"

  # CosmosDB Account Settings
  name   = "${local.project}-mongodb-account"
  domain = var.domain

  # Network
  subnet_id = module.cosmos_snet.id
  private_endpoint_config = {
    enabled                       = var.cosmos_mongo_db_params.private_endpoint_enabled
    name_mongo                    = "${local.project}-cosmos-pe"
    service_connection_name_mongo = "${local.project}-cosmos-pe"
    private_dns_zone_mongo_ids    = [data.azurerm_private_dns_zone.cosmos.id]
  }

  main_geo_location_location = var.location
}

resource "azurerm_cosmosdb_mongo_database" "mdc" {
  count = var.is_feature_enabled.cosmos ? 1 : 0

  name                = var.domain
  resource_group_name = data.azurerm_resource_group.mdc_data_rg.name
  account_name        = module.cosmos_account.name
}

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

module "cosmosdb_collections" {
  source   = "./.terraform/modules/__v4__/cosmosdb_mongodb_collection"
  for_each = var.is_feature_enabled.cosmos ? { for index, coll in local.collections : coll.name => coll } : {}

  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.mdc_data_rg.name

  cosmosdb_mongo_account_name  = module.cosmos_account.name
  cosmosdb_mongo_database_name = azurerm_cosmosdb_mongo_database.mdc[0].name

  indexes     = each.value.indexes
  lock_enable = var.env_short == "p"

  default_ttl_seconds = each.value.name == "retrieval" ? 1800 : null
}

#-----------------------------------------------------------------------------------------------------------------------
# KV
#-----------------------------------------------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "cosmosdb_account_mongodb_connection_strings" {
  name         = "mongodb-connection-string"
  value        = module.cosmos_account.primary_connection_strings
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_domain.id

  tags = module.tag_config.tags
}

#-----------------------------------------------------------------------------------------------------------------------
# Alerts
#-----------------------------------------------------------------------------------------------------------------------
resource "azurerm_monitor_metric_alert" "cosmos_db_normalized_ru_exceeded" {
  count = var.is_feature_enabled.cosmos && var.env_short == "p" ? 1 : 0

  name                = "[${var.domain != null ? "${var.domain} | " : ""}${module.cosmos_account.name}] Normalized RU Exceeded"
  resource_group_name = data.azurerm_resource_group.mdc_data_rg.name
  scopes              = [module.cosmos_account.id]
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
      values   = [data.azurerm_resource_group.mdc_data_rg.location]
    }

    dimension {
      name     = "CollectionName"
      operator = "Include"
      values   = ["*"]
    }
  }

  # action {
  #   action_group_id = data.azurerm_monitor_action_group.email.id
  # }
  #
  # action {
  #   action_group_id = data.azurerm_monitor_action_group.slack.id
  # }

  tags = merge(
    module.tag_config.tags,
    {
      "grafana" = "yes"
    }
  )
}
