resource "null_resource" "trigger_create_tables_srtp_nsm" {
  triggers = {
    file_hash = sha256(templatefile("${path.module}/data_explorer_kql/create_tables_srtp_nsm.kql.tftpl", {
      soft_delete_period        = "${coalesce(var.adx_table_soft_delete_period_days, var.adx_db_soft_delete_period_days)}.00:00:00"
      hot_cache_period_timespan = "${coalesce(var.adx_table_hot_cache_period_days, var.adx_db_hot_cache_period_days)}.00:00:00"
      hot_cache_period          = "${coalesce(var.adx_table_hot_cache_period_days, var.adx_db_hot_cache_period_days)}d"
    }))
  }
}

resource "azapi_resource" "create_tables_srtp_nsm" {
  type      = "Microsoft.Kusto/clusters/databases/scripts@2023-08-15"
  name      = "create-table-srtp-nsm"
  parent_id = "${data.azurerm_kusto_cluster.kusto_cluster.id}/databases/${var.domain}"

  body = {
    properties = {
      scriptContent = templatefile("${path.module}/data_explorer_kql/create_tables_srtp_nsm.kql.tftpl", {
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
    replace_triggered_by = [null_resource.trigger_create_tables_srtp_nsm]
  }
}
