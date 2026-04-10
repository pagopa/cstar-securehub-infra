resource "azurerm_kusto_database" "mdc" {
  name                = var.domain
  resource_group_name = data.azurerm_kusto_cluster.kusto_cluster.resource_group_name
  location            = data.azurerm_kusto_cluster.kusto_cluster.location
  cluster_name        = data.azurerm_kusto_cluster.kusto_cluster.name

  hot_cache_period   = "P5D"
  soft_delete_period = "P7D"
}

resource "null_resource" "trigger_create_tables_mdc" {
  triggers = {
    file_hash = filesha256("${path.module}/data_explorer_kql/create_tables_mdc.kql")
  }
}

resource "azapi_resource" "create_tables_mdc" {
  type      = "Microsoft.Kusto/clusters/databases/scripts@2023-08-15"
  name      = "create-tables-${var.domain}"
  parent_id = "${data.azurerm_kusto_cluster.kusto_cluster.id}/databases/${azurerm_kusto_database.mdc.name}"

  body = {
    properties = {
      scriptContent    = file("${path.module}/data_explorer_kql/create_tables_mdc.kql")
      continueOnErrors = false
    }
  }

  response_export_values = ["properties.provisioningState"]

  depends_on = [azurerm_kusto_database.mdc]

  lifecycle {
    replace_triggered_by = [null_resource.trigger_create_tables_mdc]
  }
}

# Linked Service
resource "azurerm_data_factory_linked_service_kusto" "kusto_mdc" {
  name                     = "${var.domain}-Kusto-${var.domain}-ls"
  data_factory_id          = data.azurerm_data_factory.data_factory.id
  kusto_endpoint           = data.azurerm_kusto_cluster.kusto_cluster.uri
  kusto_database_name      = azurerm_kusto_database.mdc.name
  use_managed_identity     = true
  integration_runtime_name = "AutoResolveIntegrationRuntime"
}
