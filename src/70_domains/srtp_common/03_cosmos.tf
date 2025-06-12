module "cosmos_db_account" {
  source = "./.terraform/modules/__v4__/IDH/cosmosdb_account"

  # General
  product_name        = var.prefix
  env                 = var.env
  location            = var.location
  resource_group_name = local.data_rg
  tags                = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = "cosmos_mongo7"

  # CosmosDB Account Settings
  name   = "${local.project}-cosmos-account"
  domain = var.domain

  # Network
  subnet_id = module.private_endpoint_snet.id
  private_endpoint_config = {
    enabled                       = true
    name_mongo                    = "${local.project}-cosmos-private-endpoint"
    service_connection_name_mongo = "${local.project}-cosmos-private-endpoint"
    private_dns_zone_mongo_ids    = [data.azurerm_private_dns_zone.cosmos_mongo.id]
  }
  # Geo-location and Zone Settings
  main_geo_location_location = var.location

}
