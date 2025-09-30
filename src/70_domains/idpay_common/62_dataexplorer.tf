resource "azurerm_kusto_database" "product" {
  name                = "products"
  resource_group_name = data.azurerm_kusto_cluster.kusto_cluster.resource_group_name
  location            = data.azurerm_kusto_cluster.kusto_cluster.location
  cluster_name        = data.azurerm_kusto_cluster.kusto_cluster.name

  hot_cache_period   = "P5D"
  soft_delete_period = "P7D"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_data_factory_managed_private_endpoint" "adf_dataexplore_mpe" {
  name               = "${local.product}-kusto-mpe"
  data_factory_id    = data.azurerm_data_factory.data_factory.id
  target_resource_id = data.azurerm_kusto_cluster.kusto_cluster.id
  subresource_name   = "cluster"
}

data "azapi_resource" "privatelink_private_endpoint_connection" {
  type                   = "Microsoft.Kusto/clusters@2023-08-15"
  resource_id            = data.azurerm_kusto_cluster.kusto_cluster.id
  response_export_values = ["properties.privateEndpointConnections."]

  depends_on = [
    azurerm_data_factory_managed_private_endpoint.adf_dataexplore_mpe
  ]
}

locals {
  privatelink_private_endpoint_connection_name = data.azapi_resource.privatelink_private_endpoint_connection.output.properties.privateEndpointConnections[0].id
}
resource "azapi_resource_action" "kusto_approve_pe" {
  type        = "Microsoft.Kusto/clusters/privateEndpointConnections@2024-04-13"
  resource_id = local.privatelink_private_endpoint_connection_name
  method      = "PUT"

  body = {
    properties = {
      privateLinkServiceConnectionState = {
        description = "Approved via Terraform - ${azurerm_data_factory_managed_private_endpoint.adf_dataexplore_mpe.name}"
        status      = "Approved"
      }
    }
  }
}

resource "azurerm_data_factory_linked_service_kusto" "kusto" {
  name                 = "AzureKusto${data.azurerm_kusto_cluster.kusto_cluster.name}LinkService"
  data_factory_id      = data.azurerm_data_factory.data_factory.id
  kusto_endpoint       = data.azurerm_kusto_cluster.kusto_cluster.uri
  kusto_database_name  = azurerm_kusto_database.product.name
  use_managed_identity = true
}

resource "azurerm_kusto_database_principal_assignment" "adf_mi" {
  name                = "adf-managed-identity"
  database_name       = azurerm_kusto_database.product.name
  cluster_name        = data.azurerm_kusto_cluster.kusto_cluster.name
  resource_group_name = data.azurerm_kusto_cluster.kusto_cluster.resource_group_name

  principal_id   = data.azurerm_data_factory.data_factory.identity[0].principal_id
  principal_type = "App"
  tenant_id      = data.azurerm_client_config.current.tenant_id
  role           = "Admin"
}
