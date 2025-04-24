module "idpay_cosmos_mongodb_account" {
  source = "./.terraform/modules/__v4__/cosmosdb_account"

  name                = "${local.project}-mongodb-account"
  domain              = var.domain
  location            = data.azurerm_resource_group.idpay_data_rg.location
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  offer_type          = var.cosmos_mongo_account_params.offer_type
  enable_free_tier    = var.cosmos_mongo_account_params.enable_free_tier
  kind                = "MongoDB"
  capabilities        = var.cosmos_mongo_account_params.capabilities

  #mongo_server_version = var.cosmos_mongo_account_params.server_version

  subnet_id = module.idpay_cosmosdb_snet.id

  private_dns_zone_mongo_ids            = [data.azurerm_private_dns_zone.cosmos_mongo.id]
  private_endpoint_mongo_name           = "${local.project}-mongodb-account-private-endpoint"
  private_service_connection_mongo_name = "${var.env_short}-mongodb-account-private-endpoint"
  # is_virtual_network_filter_enabled     = var.cosmos_mongo_account_params.is_virtual_network_filter_enabled

  allowed_virtual_network_subnet_ids = [
    # data.azurerm_subnet.aks_domain_subnet.id
  ]

  consistency_policy               = var.cosmos_mongo_account_params.consistency_policy
  main_geo_location_location       = data.azurerm_resource_group.idpay_data_rg.location
  main_geo_location_zone_redundant = var.cosmos_mongo_account_params.main_geo_location_zone_redundant
  additional_geo_locations         = var.cosmos_mongo_account_params.additional_geo_locations

  backup_continuous_enabled = var.cosmos_mongo_account_params.backup_continuous_enabled

  tags = var.tags
}

#
# 🔑 Secrets
#
resource "azurerm_key_vault_secret" "cosmosdb_account_mongodb_primary_connection_strings" {
  name         = "mongodb-primary-connection-string"
  value        = module.idpay_cosmos_mongodb_account.primary_connection_strings
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

resource "azurerm_key_vault_secret" "cosmosdb_account_mongodb_secondary_connection_strings" {
  name         = "mongodb-secondary-connection-string"
  value        = module.idpay_cosmos_mongodb_account.secondary_connection_strings
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.domain_kv.id
}
