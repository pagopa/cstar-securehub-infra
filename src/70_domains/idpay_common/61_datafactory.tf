resource "azurerm_data_factory_linked_custom_service" "adf_cosmosdb_linked_service" {
  for_each = {
    for i in local.adf_cosmosdb_linked_services : i.name => i
  }

  name            = "${var.domain}-CosmosDB-${each.key}-ls"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  type            = "CosmosDbMongoDbApi"
  type_properties_json = jsonencode({
    connectionString       = module.cosmos_db_account.primary_connection_strings
    account                = module.cosmos_db_account.name
    database               = each.key
    isServerVersionAbove32 = true
  })

  integration_runtime {
    name = "AutoResolveIntegrationRuntime"
  }
}

resource "azurerm_data_factory_linked_custom_service" "bonus_blob_storage_linked_service" {

  name            = "${var.domain}-bonus-blob-storage-ls"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  type            = "AzureBlobStorage"
  description     = "Bonus Blob Storage Account linked service for IdPay"
  type_properties_json = jsonencode({
    connectionString = module.cdn_idpay_bonuselettrodomestici.storage_primary_connection_string
  })

  integration_runtime {
    name = "AutoResolveIntegrationRuntime"
  }
}

resource "azurerm_data_factory_managed_private_endpoint" "adf_cosmosdb_mpe" {
  name               = "${local.product}-cosmosdb-mongo-mpe"
  data_factory_id    = data.azurerm_data_factory.data_factory.id
  target_resource_id = module.cosmos_db_account.id
  subresource_name   = "MongoDB"
}

data "azapi_resource" "cosmos_pe_connection" {
  type      = "Microsoft.DocumentDB/databaseAccounts/privateEndpointConnections@2021-04-15"
  parent_id = module.cosmos_db_account.id
  name      = "${data.azurerm_data_factory.data_factory.name}.${azurerm_data_factory_managed_private_endpoint.adf_cosmosdb_mpe.name}"

  depends_on = [azurerm_data_factory_managed_private_endpoint.adf_cosmosdb_mpe]
}

resource "azapi_resource_action" "approve_pe" {
  type        = "Microsoft.DocumentDB/databaseAccounts/privateEndpointConnections@2021-04-15"
  resource_id = data.azapi_resource.cosmos_pe_connection.id
  method      = "PUT"

  body = {
    properties = {
      privateLinkServiceConnectionState = {
        description = "Approved via Terraform - ${azurerm_data_factory_managed_private_endpoint.adf_cosmosdb_mpe.name}"
        status      = "Approved"
      }
    }
  }
}
