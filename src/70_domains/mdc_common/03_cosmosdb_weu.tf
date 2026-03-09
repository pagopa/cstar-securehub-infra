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

resource "azurerm_cosmosdb_mongo_database" "mongo_db_weu" {
  name                = "mil"
  resource_group_name = azurerm_resource_group.cosmosdb_mil_rg[0].name
  account_name        = module.cosmosdb_account_mongodb_weu[0].name

  dynamic "autoscale_settings" {
    for_each = var.cosmos_mongodb_common_configuration.autoscale_enabled ? [1] : []
    content {
      max_throughput = var.cosmos_mongodb_common_configuration.max_throughput
    }
  }
}

module "cosmosdb_collections_weu" {
  source   = "./.terraform/modules/__v4__/cosmosdb_mongodb_collection"
  for_each = var.enable_cosmos_db_weu ? { for index, coll in local.collections : coll.name => coll } : {}

  name                = each.value.name
  resource_group_name = azurerm_resource_group.cosmosdb_mil_rg[0].name

  cosmosdb_mongo_account_name  = module.cosmosdb_account_mongodb_weu[0].name
  cosmosdb_mongo_database_name = azurerm_cosmosdb_mongo_database.mongo_db_weu.name

  indexes     = each.value.indexes
  lock_enable = var.env_short == "p"

  default_ttl_seconds = each.value.name == "retrieval" ? 1800 : null
}
