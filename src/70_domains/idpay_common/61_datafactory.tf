resource "azurerm_data_factory_linked_service_cosmosdb" "adf_cosmosdb_linked_service" {
  for_each = toset(local.adf_cosmosdb_linked_services)

  name             = "${each.value}Linkedservice"
  data_factory_id  = data.azurerm_data_factory.data_factory.id
  account_endpoint = module.cosmos_db_account.endpoint
  account_key      = module.cosmos_db_account.primary_key
  database         = each.value

}
