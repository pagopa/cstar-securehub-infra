resource "azurerm_data_factory_linked_custom_service" "adf_cosmosdb_mdc_ls" {
  name            = "${var.domain}-CosmosDB-${var.domain}-ls"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  type            = "CosmosDbMongoDbApi"

  type_properties_json = jsonencode({
    connectionString = module.cosmos_account.primary_connection_strings

    database = azurerm_cosmosdb_mongo_database.mongo_db.name

    isServerVersionAbove32 = true
  })

  integration_runtime {
    name = "AutoResolveIntegrationRuntime"
  }

  depends_on = [azurerm_data_factory_managed_private_endpoint.adf_cosmosdb_mpe]
}

resource "azurerm_data_factory_linked_custom_service" "adf_log_analytics_ls" {
  name            = "${var.domain}-LogAnalytics-${var.domain}-ls"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  type            = "AzureLogAnalytics"

  type_properties_json = jsonencode({
    workspaceId        = data.azurerm_log_analytics_workspace.domain_log_analytics.workspace_id
    authenticationType = "MSI"
  })

  integration_runtime {
    name = "AutoResolveIntegrationRuntime"
  }
}

resource "azurerm_data_factory_managed_private_endpoint" "adf_cosmosdb_mpe" {
  name               = "${local.project}-cosmosdb-mongo-mpe"
  data_factory_id    = data.azurerm_data_factory.data_factory.id
  target_resource_id = module.cosmos_account.id
  subresource_name   = "MongoDB"
}

data "azapi_resource" "cosmos_pe_connection" {
  type      = "Microsoft.DocumentDB/databaseAccounts/privateEndpointConnections@2021-04-15"
  parent_id = module.cosmos_account.id
  name      = "${data.azurerm_data_factory.data_factory.name}.${azurerm_data_factory_managed_private_endpoint.adf_cosmosdb_mpe.name}"

  depends_on = [azurerm_data_factory_managed_private_endpoint.adf_cosmosdb_mpe]
}

resource "azapi_resource_action" "cosmos_approve_pe" {
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
