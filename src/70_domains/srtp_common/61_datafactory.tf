resource "azurerm_data_factory_linked_custom_service" "adf_cosmosdb_linked_service" {
  for_each = local.cosmos_db

  name            = "${var.domain}-CosmosDB-${each.key}-ls"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  type            = "CosmosDbMongoDbApi"
  type_properties_json = jsonencode({
    connectionString       = module.cosmos_db_account.primary_connection_strings
    database               = each.key
    isServerVersionAbove32 = true
  })

  integration_runtime {
    name = "AutoResolveIntegrationRuntime"
  }

  depends_on = [azurerm_data_factory_managed_private_endpoint.adf_cosmosdb_mpe]
}

resource "azurerm_data_factory_managed_private_endpoint" "adf_cosmosdb_mpe" {
  name               = "${local.project}-cosmosdb-mongo-mpe"
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

# ADF MI -> can read KV secrets
resource "azurerm_role_assignment" "adf_can_read_kv_secrets" {
  scope                = data.azurerm_key_vault.domain_kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_data_factory.data_factory.identity[0].principal_id
}

resource "azurerm_key_vault_access_policy" "kv_policy_adf" {
  key_vault_id       = data.azurerm_key_vault.domain_kv.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_data_factory.data_factory.identity[0].principal_id
  secret_permissions = ["Get"]
}
