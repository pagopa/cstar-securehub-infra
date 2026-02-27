resource "azurerm_resource_group" "cosmosdb_mil_rg" {
  count = var.enable_cosmos_db_weu ? 1 : 0

  name     = "${local.product}-weu-mil-cosmosdb-rg"
  location = "westeurope"

  tags = module.tag_config.tags
}

module "subnet_cosmosdb_account_weu" {
  source = "./.terraform/modules/__v4__/IDH/subnet"
  count  = var.enable_cosmos_db_weu ? 1 : 0

  product_name      = var.prefix
  env               = var.env
  idh_resource_tier = "slash28_privatelink_true"

  name = "${local.project}-mdc-pe-snet"

  resource_group_name  = local.vnet_network_rg
  virtual_network_name = local.vnet_spoke_data_name

  service_endpoints = [
    "Microsoft.AzureCosmosDB",
  ]
  tags = module.tag_config.tags
}

module "cosmosdb_account_mongodb_weu" {
  source = "./.terraform/modules/__v4__/cosmosdb_account"
  count  = var.enable_cosmos_db_weu ? 1 : 0

  name                = "${local.product}-weu-mil-cosmos-account"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.cosmosdb_mil_rg[0].name
  domain              = "mil"

  offer_type   = var.cosmos_mongodb_params_weu.offer_type
  kind         = var.cosmos_mongodb_params_weu.kind
  capabilities = var.cosmos_mongodb_params_weu.capabilities

  enable_free_tier = var.cosmos_mongodb_params_weu.enable_free_tier

  public_network_access_enabled     = false
  private_endpoint_enabled          = true
  subnet_id                         = module.subnet_cosmosdb_account_weu[0].id
  private_endpoint_rg_name          = data.azurerm_resource_group.mdc_data_rg.name
  private_endpoint_location         = var.location
  private_dns_zone_mongo_ids        = [data.azurerm_private_dns_zone.cosmos.id]
  is_virtual_network_filter_enabled = var.cosmos_mongodb_params_weu.is_virtual_network_filter_enabled

  consistency_policy               = var.cosmos_mongodb_params_weu.consistency_policy
  main_geo_location_location       = var.location
  main_geo_location_zone_redundant = var.cosmos_mongodb_params_weu.main_geo_location_zone_redundant
  additional_geo_locations         = var.cosmos_mongodb_params_weu.additional_geo_locations

  backup_continuous_enabled = var.cosmos_mongodb_params_weu.backup_continuous_enabled
  ip_range                  = var.cosmos_mongodb_params_weu.ip_range_filter

  tags = module.tag_config.tags
}

import {
  for_each = { for index, coll in local.collections : coll.name => coll }

  to = module.cosmosdb_collections[each.key].azurerm_cosmosdb_mongo_collection.this
  id = "/subscriptions/88c709b0-11cf-4450-856e-f9bf54051c1d/resourceGroups/cstar-p-weu-mil-cosmosdb-rg/providers/Microsoft.DocumentDB/databaseAccounts/cstar-p-weu-mil-cosmos-account/mongodbDatabases/mil/collections/${each.value.name}"
}

import {
  for_each = { for index, coll in local.collections : coll.name => coll }

  to = module.cosmosdb_collections[each.key].azurerm_management_lock.this[0]
  id = "/subscriptions/88c709b0-11cf-4450-856e-f9bf54051c1d/resourceGroups/cstar-p-weu-mil-cosmosdb-rg/providers/Microsoft.DocumentDB/databaseAccounts/cstar-p-weu-mil-cosmos-account/mongodbDatabases/mil/collections/${each.value.name}/providers/Microsoft.Authorization/locks/mongodb-collection-${each.value.name}-lock"
}

import {
  to = module.cosmosdb_account_mongodb_weu[0].azurerm_cosmosdb_account.this
  id = "/subscriptions/88c709b0-11cf-4450-856e-f9bf54051c1d/resourceGroups/cstar-p-weu-mil-cosmosdb-rg/providers/Microsoft.DocumentDB/databaseAccounts/cstar-p-weu-mil-cosmos-account"
}

import {
  to = azurerm_resource_group.cosmosdb_mil_rg[0]
  id = "/subscriptions/88c709b0-11cf-4450-856e-f9bf54051c1d/resourceGroups/cstar-p-weu-mil-cosmosdb-rg"
}

import {
  to = module.cosmosdb_account_mongodb_weu[0].azurerm_monitor_metric_alert.cosmos_db_provisioned_throughput_exceeded[0]
  id = "/subscriptions/88c709b0-11cf-4450-856e-f9bf54051c1d/resourceGroups/cstar-p-weu-mil-cosmosdb-rg/providers/Microsoft.Insights/metricAlerts/[mil | cstar-p-weu-mil-cosmos-account] Provisioned Throughput Exceeded"
}

import {
  to = azurerm_cosmosdb_mongo_database.mongo_db
  id = "/subscriptions/88c709b0-11cf-4450-856e-f9bf54051c1d/resourceGroups/cstar-p-weu-mil-cosmosdb-rg/providers/Microsoft.DocumentDB/databaseAccounts/cstar-p-weu-mil-cosmos-account/mongodbDatabases/mil"
}
