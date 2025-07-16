locals {
  # 🍀 Cosmos DB Collection
  cosmos_db = {
    mil = {
      clients = {
        indexes = [
          {
            keys   = ["_id"]
            unique = true
          },
          {
            keys   = ["clientId"]
            unique = true
          }
        ]
      }
      roles = {
        indexes = [
          {
            keys   = ["_id"]
            unique = true
          },
          {
            keys   = ["id"]
            unique = true
          },
          {
            keys = [
              "clientId",
              "acquirerId",
              "channel",
              "merchantId",
              "terminalId"
            ]
            unique = true
          }
        ]
      }
      users = {
        indexes = [
          {
            keys   = ["_id"]
            unique = true
          },
          {
            keys = [
              "username",
              "clientId"
            ]
            unique = true
          }
        ]
      }
      revokedRefreshTokens = {
        default_ttl_seconds = local.revoked_refresh_tokens_ttl
        indexes = [
          {
            keys   = ["_id"]
            unique = true
          },
          {
            keys   = ["jwtId"]
            unique = true
          }
        ]
      }
      revokedRefreshTokensGenerations = {
        default_ttl_seconds = local.revoked_refresh_tokens_ttl
        indexes = [
          {
            keys   = ["_id"]
            unique = true
          },
          {
            keys   = ["generationId"]
            unique = true
          }
        ]
      }
    }
  }

  cosmos_collections = flatten([
    for db_name, db in local.cosmos_db : [
      for coll_name, coll in db : {
        db_name   = db_name
        coll_name = coll_name
        indexes   = coll.indexes
      }
    ]
  ])
}

# ------------------------------------------------------------------------------
# Collections
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_collection" "mongo_collection" {
  for_each = {
    for i in local.cosmos_collections :
    "${i.db_name}.${i.coll_name}" => i
  }

  name                = each.value.coll_name
  resource_group_name = local.data_rg_name
  account_name        = module.cosmos_db_account.name
  database_name       = each.value.db_name
  default_ttl_seconds = lookup(each.value, "default_ttl_seconds", null)

  dynamic "index" {
    for_each = each.value.indexes
    content {
      keys   = index.value.keys
      unique = index.value.unique
    }
  }

  dynamic "autoscale_settings" {
    for_each = var.env_short != "d" ? [1] : []
    content {
      max_throughput = 1000
    }
  }
}
