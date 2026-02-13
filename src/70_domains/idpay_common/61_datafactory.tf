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

# LS ADLS Gen2 (BlobFS) via Managed Identity
resource "azurerm_data_factory_linked_custom_service" "idpay_exports_blobfs_ls" {
  name            = "${var.domain}-exports-blobfs-ls"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  type            = "AzureBlobFS"
  description     = "Exports Storage (ADLS Gen2) via Managed Identity"

  type_properties_json = jsonencode({
    url            = "https://${module.storage_idpay_exports.name}.dfs.core.windows.net"
    authentication = "ManagedIdentity"
  })

  integration_runtime {
    name = "AutoResolveIntegrationRuntime"
  }

  depends_on = [azurerm_role_assignment.adf_can_access_exports_storage]
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
# ADF MI -> can read kv secrets
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

#ADF secrets
resource "azurerm_key_vault_secret" "data_factory_name" {
  name         = "data-factory-name"
  value        = local.data_factory_name
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

resource "azurerm_key_vault_secret" "data_factory_rg_name" {
  name         = "data-factory-rg-name"
  value        = local.data_factory_rg_name
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

# needed for client application
resource "azurerm_key_vault_secret" "data_factory_rg_name" {
  name         = "idpay-tenant-id"
  value        = data.azurerm_client_config.current.tenant_id
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

resource "azurerm_key_vault_secret" "data_factory_rg_name" {
  name         = "idpay-subscription-id"
  value        = data.azurerm_subscription.current.subscription_id
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}
