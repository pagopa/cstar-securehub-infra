module "cosmos_account" {
  source = "./.terraform/modules/__v4__/IDH/cosmosdb_account"
  count  = !var.enable_cosmos_db_weu ? 1 : 0

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
    enabled                       = true
    name_mongo                    = "${local.project}-cosmos-pe"
    service_connection_name_mongo = "${local.project}-cosmos-pe"
    private_dns_zone_mongo_ids    = [data.azurerm_private_dns_zone.cosmos.id]
  }

  main_geo_location_location = var.location
}
