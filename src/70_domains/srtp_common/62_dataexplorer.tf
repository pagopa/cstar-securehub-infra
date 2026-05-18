resource "azurerm_kusto_database" "db" {
  for_each = local.kusto_database

  name                = each.key
  resource_group_name = data.azurerm_kusto_cluster.kusto_cluster.resource_group_name
  location            = data.azurerm_kusto_cluster.kusto_cluster.location
  cluster_name        = data.azurerm_kusto_cluster.kusto_cluster.name

  hot_cache_period   = each.value.hot_cache_period
  soft_delete_period = each.value.soft_delete_period
}

resource "null_resource" "trigger_create_tables_srtp" {
  triggers = {
    file_hash = sha256(templatefile("${path.module}/data_explorer_kql/create_tables_srtp.kql.tftpl", {
      soft_delete_period        = "${coalesce(var.adx_table_soft_delete_period_days, var.adx_db_soft_delete_period_days)}.00:00:00"
      hot_cache_period_timespan = "${coalesce(var.adx_table_hot_cache_period_days, var.adx_db_hot_cache_period_days)}.00:00:00"
      hot_cache_period          = "${coalesce(var.adx_table_hot_cache_period_days, var.adx_db_hot_cache_period_days)}d"
    }))
  }
}

resource "azapi_resource" "create_tables_srtp" {
  type      = "Microsoft.Kusto/clusters/databases/scripts@2023-08-15"
  name      = "create-table-srtp"
  parent_id = "${data.azurerm_kusto_cluster.kusto_cluster.id}/databases/${var.domain}"

  body = {
    properties = {
      scriptContent = templatefile("${path.module}/data_explorer_kql/create_tables_srtp.kql.tftpl", {
        soft_delete_period        = "${coalesce(var.adx_table_soft_delete_period_days, var.adx_db_soft_delete_period_days)}.00:00:00"
        hot_cache_period_timespan = "${coalesce(var.adx_table_hot_cache_period_days, var.adx_db_hot_cache_period_days)}.00:00:00"
        hot_cache_period          = "${coalesce(var.adx_table_hot_cache_period_days, var.adx_db_hot_cache_period_days)}d"
      })
      continueOnErrors = false
    }
  }

  response_export_values = ["properties.provisioningState"]
  depends_on = [
    azurerm_kusto_database.db
  ]
  lifecycle {
    replace_triggered_by = [null_resource.trigger_create_tables_srtp]
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

resource "azurerm_kusto_database_principal_assignment" "rtp_sender_adx_viewer" {
  name                = "rtp-role-viewer"
  resource_group_name = data.azurerm_kusto_cluster.kusto_cluster.resource_group_name
  cluster_name        = data.azurerm_kusto_cluster.kusto_cluster.name
  database_name       = azurerm_kusto_database.db[var.domain].name

  principal_id   = data.azurerm_user_assigned_identity.rtp_sender_workload_identity.client_id
  principal_type = "App"
  tenant_id      = data.azurerm_client_config.current.tenant_id
  role           = "Viewer"
}

resource "azurerm_kusto_database_principal_assignment" "rtp_sender_adx_ingestor" {
  name                = "rtp-role-ingestor"
  resource_group_name = data.azurerm_kusto_cluster.kusto_cluster.resource_group_name
  cluster_name        = data.azurerm_kusto_cluster.kusto_cluster.name
  database_name       = azurerm_kusto_database.db[var.domain].name

  principal_id   = data.azurerm_user_assigned_identity.rtp_sender_workload_identity.client_id
  principal_type = "App"
  tenant_id      = data.azurerm_client_config.current.tenant_id
  role           = "Ingestor"
}
