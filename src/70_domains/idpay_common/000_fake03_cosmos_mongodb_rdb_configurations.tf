#
# Fake database rdb
#
resource "azurerm_cosmosdb_mongo_database" "fake_rdb" {
  name                = "rdb"
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  account_name        = module.fake_cosmos_db_account.name

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
# Fake collection rdb
#
resource "azurerm_cosmosdb_mongo_collection" "fake_mongodb_collections_rdb" {
  for_each = {
    for index, coll in local.collections_rdb :
    coll.name => coll
  }

  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name

  account_name  = module.fake_cosmos_db_account.name
  database_name = azurerm_cosmosdb_mongo_database.fake_rdb.name

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
