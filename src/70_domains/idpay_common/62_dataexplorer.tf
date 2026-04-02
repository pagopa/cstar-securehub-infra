resource "azurerm_kusto_database" "db" {
  for_each = local.kusto_database

  name                = each.key
  resource_group_name = data.azurerm_kusto_cluster.kusto_cluster.resource_group_name
  location            = data.azurerm_kusto_cluster.kusto_cluster.location
  cluster_name        = data.azurerm_kusto_cluster.kusto_cluster.name

  hot_cache_period   = each.value.hot_cache_period
  soft_delete_period = each.value.soft_delete_period
}

resource "null_resource" "trigger_create_tables_idpay" {
  triggers = {
    file_hash = filesha256("${path.module}/data_explorer_kql/create_tables_idpay.kql")
  }
}

resource "azapi_resource" "create_tables_idpay" {
  type      = "Microsoft.Kusto/clusters/databases/scripts@2023-08-15"
  name      = "create-table-idpay"
  parent_id = "${data.azurerm_kusto_cluster.kusto_cluster.id}/databases/idpay"

  body = {
    properties = {
      scriptContent    = file("${path.module}/data_explorer_kql/create_tables_idpay.kql")
      continueOnErrors = false
    }
  }

  response_export_values = ["properties.provisioningState"]
  depends_on = [
    azurerm_kusto_database.db
  ]
  lifecycle {
    replace_triggered_by = [null_resource.trigger_create_tables_idpay]
  }
}

resource "azurerm_data_factory_managed_private_endpoint" "adf_dataexplorer_mpe" {
  name               = "${local.project}-kusto-mpe"
  data_factory_id    = data.azurerm_data_factory.data_factory.id
  target_resource_id = data.azurerm_kusto_cluster.kusto_cluster.id
  subresource_name   = "cluster"
}

data "azapi_resource" "privatelink_private_endpoint_connection" {
  type                   = "Microsoft.Kusto/clusters@2023-08-15"
  resource_id            = data.azurerm_kusto_cluster.kusto_cluster.id
  response_export_values = ["properties.privateEndpointConnections."]

  depends_on = [
    azurerm_data_factory_managed_private_endpoint.adf_dataexplorer_mpe
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
        description = "Approved via Terraform - ${azurerm_data_factory_managed_private_endpoint.adf_dataexplorer_mpe.name}"
        status      = "Approved"
      }
    }
  }
}

resource "azurerm_data_factory_linked_service_kusto" "kusto" {
  for_each = local.kusto_database

  name                 = "${var.domain}-Kusto-${each.key}-ls"
  data_factory_id      = data.azurerm_data_factory.data_factory.id
  kusto_endpoint       = data.azurerm_kusto_cluster.kusto_cluster.uri
  kusto_database_name  = azurerm_kusto_database.db[each.key].name
  use_managed_identity = true

  integration_runtime_name = "AutoResolveIntegrationRuntime"
}
