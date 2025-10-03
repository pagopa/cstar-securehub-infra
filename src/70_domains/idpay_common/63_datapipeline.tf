locals {
  linked_service_placeholders = merge(
    {
      for db in local.adf_cosmosdb_linked_services :
      "linkedService_CosmosDb_${db}" => "${var.domain}-CosmosDB-${db}-ls"
    },
    {
      for db in keys(local.kusto_database) :
      "linkedService_Kusto_${db}" => "${var.domain}-Kusto-${db}-ls"
    }
  )

  dataset_templates = {
    for file in fileset("${path.module}/dataset_templates", "*.json.tpl") :
    trimsuffix(file, ".json.tpl") => jsondecode(templatefile("${path.module}/dataset_templates/${file}", local.linked_service_placeholders))
  }

  pipeline_templates = {
    for file in fileset("${path.module}/pipeline", "*.json") :
    trimsuffix(file, ".json") => jsondecode(file("${path.module}/pipeline_templates/${file}"))
  }
}

resource "azurerm_data_factory_custom_dataset" "datasets" {
  for_each = local.dataset_templates

  name            = each.value.name
  data_factory_id = data.azurerm_data_factory.data_factory.id
  type            = each.value.type

  linked_service {
    name = each.value.properties.linkedServiceName.referenceName
  }

  type_properties_json = jsonencode(each.value.properties.typeProperties)

  description = lookup(each.value, "description", null)
  annotations = lookup(each.value, "annotations", [])

  parameters  = lookup(each.value, "parameters", null)
  schema_json = lookup(each.value, "schema", null)
}

resource "azurerm_data_factory_pipeline" "pipelines" {
  for_each = local.pipeline_templates

  name            = each.value.name
  data_factory_id = data.azurerm_data_factory.data_factory.id
  annotations     = []

  activities_json = jsonencode(each.value.properties.activities)
}
