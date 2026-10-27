locals {

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
      name = "initiatives_config"
      indexes = [
        {
          keys   = ["_id"]
          unique = true
        }
      ]
    },
    {
      name = "producers_initiative"
      indexes = [
        {
          keys   = ["_id"]
          unique = true
        },
        {
          keys   = ["producerId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        },
        {
          keys   = ["initiativeName"]
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
          keys   = ["productCode"]
          unique = false
        },
        {
          keys   = ["gtinCode"]
          unique = false
        },
        {
          keys   = ["fullProductName"]
          unique = false
        },
        {
          keys   = ["brand"]
          unique = false
        },
        {
          keys   = ["model"]
          unique = false
        },
        {
          keys   = ["organizationName"]
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
# Database rdb
#
resource "azurerm_cosmosdb_mongo_database" "rdb" {
  name                = "rdb"
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

  # Inherit database throughput in provisioned environments; DEV keeps serverless settings.
  # Existing dedicated collections require the coordinated dump/recreate/import procedure.
  throughput = null

  dynamic "index" {
    for_each = each.value.indexes
    iterator = index
    content {
      keys   = index.value.keys
      unique = index.value.unique
    }
  }

  timeouts {
  }
}
