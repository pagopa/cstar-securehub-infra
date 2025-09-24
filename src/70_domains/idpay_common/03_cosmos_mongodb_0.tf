# ------------------------------------------------------------------------------
# CosmosDB NoSQL account --> MongoDB
# ------------------------------------------------------------------------------
module "cosmos_db_account" {
  source = "./.terraform/modules/__v4__/IDH/cosmosdb_account"

  # General
  product_name        = var.prefix
  env                 = var.env
  location            = var.location
  resource_group_name = local.data_rg
  tags                = merge(module.tag_config.tags, { grafana = "yes" })

  # IDH Resources
  idh_resource_tier = "cosmos_mongo7"

  # CosmosDB Account Settings
  name   = "${local.project}-mongodb-account"
  domain = var.domain

  # Network
  subnet_id = module.private_endpoint_cosmos_snet.id
  private_endpoint_config = {
    enabled                       = true
    name_mongo                    = "${local.project}-cosmos-private-endpoint"
    service_connection_name_mongo = "${local.project}-cosmos-private-endpoint"
    private_dns_zone_mongo_ids    = [data.azurerm_private_dns_zone.cosmos_mongo.id]
  }

  # Geo-location and Zone Settings
  main_geo_location_location = var.location
}

#
# 🔑 Secrets
#
resource "azurerm_key_vault_secret" "cosmosdb_account_mongodb_primary_connection_strings" {
  name         = "mongodb-primary-connection-string"
  value        = module.cosmos_db_account.primary_connection_strings
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.domain_kv.id

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "cosmosdb_account_mongodb_secondary_connection_strings" {
  name         = "mongodb-secondary-connection-string"
  value        = module.cosmos_db_account.secondary_connection_strings
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.domain_kv.id

  tags = module.tag_config.tags
}
