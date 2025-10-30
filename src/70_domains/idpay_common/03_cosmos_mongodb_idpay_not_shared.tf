# ------------------------------------------------------------------------------
# CosmosDB MongoDB databases and collections
# ------------------------------------------------------------------------------
locals {

  idpay_hot_collections = [
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
      name                = "notification"
      shard_key           = null
      default_ttl_seconds = null
      indexes = [
        { keys = ["_id"], unique = true },
        { keys = ["notificationStatus"], unique = false },
        { keys = ["retry"], unique = false },
        { keys = ["retryDate"], unique = false },
        { keys = ["initiativeId"], unique = false }
      ]
    },
  ]

  plan_idpay_hot = {
    for coll in local.idpay_hot_collections :
    "idpay-hot.${coll.name}" => merge(coll, { database_name = "idpay-hot" })
  }

  collections_not_shared_plan = merge(
    local.plan_idpay_hot
  )
}


# ------------------------------------------------------------------------------
# Databases
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_database" "databases_not_shared" {
  for_each = toset([
    "idpay-hot",
  ])

  name                = each.key
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  account_name        = module.cosmos_db_account.name

  throughput = null

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
module "cosmos_mongodb_collections_not_shared" {
  for_each = local.collections_not_shared_plan

  source = "./.terraform/modules/__v4__/cosmosdb_mongodb_collection"

  name                         = each.value.name
  resource_group_name          = data.azurerm_resource_group.idpay_data_rg.name
  cosmosdb_mongo_account_name  = module.cosmos_db_account.name
  cosmosdb_mongo_database_name = azurerm_cosmosdb_mongo_database.databases_not_shared[each.value.database_name].name

  shard_key           = each.value.shard_key
  default_ttl_seconds = each.value.default_ttl_seconds
  indexes             = each.value.indexes
  max_throughput      = var.env == "dev" ? null : 1000
}
