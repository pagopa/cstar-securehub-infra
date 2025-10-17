# ------------------------------------------------------------------------------
# Fake CosmosDB MongoDB databases and collections
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_database" "fake_databases" {
  for_each = toset([
    "idpay-beneficiari",
    "idpay-pagamenti",
    "idpay-iniziative",
  ])

  name                = each.key
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  account_name        = module.fake_cosmos_db_account.name

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

module "fake_cosmos_mongodb_collections" {
  for_each = local.collections_plan

  source = "./.terraform/modules/__v4__/cosmosdb_mongodb_collection"

  name                         = each.value.name
  resource_group_name          = data.azurerm_resource_group.idpay_data_rg.name
  cosmosdb_mongo_account_name  = module.fake_cosmos_db_account.name
  cosmosdb_mongo_database_name = azurerm_cosmosdb_mongo_database.fake_databases[each.value.database_name].name

  shard_key           = each.value.shard_key
  default_ttl_seconds = each.value.default_ttl_seconds
  indexes             = each.value.indexes
  throughput          = null
  max_throughput      = null
}

