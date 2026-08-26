locals {
  # KQL files in data_factory_queries can be referenced from *.json.tftpl pipelines
  # with queries["<file-name-without-extension>"].
  data_factory_queries = {
    for file in fileset("${path.module}/data_factory_queries", "*.kql") :
    trimsuffix(file, ".kql") => trimspace(file("${path.module}/data_factory_queries/${file}"))
  }

  pipeline_json_templates = {
    for file in fileset("${path.module}/data_factory_pipelines", "*.json") :
    jsondecode(file("${path.module}/data_factory_pipelines/${file}")).name => jsondecode(file("${path.module}/data_factory_pipelines/${file}"))
  }

  pipeline_tftpl_templates = {
    for file in fileset("${path.module}/data_factory_pipelines", "*.json.tftpl") :
    jsondecode(templatefile("${path.module}/data_factory_pipelines/${file}", {
      domain            = var.domain
      queries           = local.data_factory_queries
      law_id            = azurerm_log_analytics_workspace.log_analytics_workspace.id
      law_name          = azurerm_log_analytics_workspace.log_analytics_workspace.name
      })).name => jsondecode(templatefile("${path.module}/data_factory_pipelines/${file}", {
      domain            = var.domain
      queries           = local.data_factory_queries
      law_id            = azurerm_log_analytics_workspace.log_analytics_workspace.id
      law_name          = azurerm_log_analytics_workspace.log_analytics_workspace.name
    }))
  }

  pipeline_templates = merge(local.pipeline_json_templates, local.pipeline_tftpl_templates)

}

resource "azurerm_data_factory_pipeline" "pipelines" {
  for_each = local.pipeline_templates

  name            = each.key
  data_factory_id = data.azurerm_data_factory.data_factory.id
  annotations     = []

  parameters = try(
    { for k, v in each.value["properties"]["parameters"] : k => "" },
    {}
  )

  activities_json = jsonencode(each.value["properties"]["activities"])

  depends_on = [
    azapi_resource.create_tables_srtp,
    azapi_resource.create_tables_srtp_nsm,
    azurerm_data_factory_custom_dataset.datasets,
    azurerm_data_factory_linked_custom_service.adf_cosmosdb_linked_service,
    azurerm_data_factory_linked_custom_service.log_analytics_ls,
    azurerm_data_factory_linked_service_kusto.kusto_srtp,
  ]
}
