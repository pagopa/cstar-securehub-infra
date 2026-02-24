locals {

  dataset_templates = {
    for file in fileset("${path.module}/data_factory_datasets", "*.json") :
    jsondecode(templatefile("${path.module}/data_factory_datasets/${file}", {
      domain = var.domain
      })).name => jsondecode(templatefile("${path.module}/data_factory_datasets/${file}", {
      domain = var.domain
    }))
  }

}

resource "azurerm_data_factory_custom_dataset" "datasets" {
  for_each = local.dataset_templates

  name            = each.key
  data_factory_id = data.azurerm_data_factory.data_factory.id
  type            = each.value.properties.type

  linked_service {
    name = each.value.properties.linkedServiceName.referenceName
  }

  type_properties_json = jsonencode(each.value.properties.typeProperties)

  description = try(each.value.properties.description, null)
  annotations = try(each.value.properties.annotations, [])

  parameters = try(
    { for k, v in each.value.properties.parameters : k => v.type },
    null
  )
  schema_json = try(jsonencode(each.value.properties.schema), null)

  depends_on = [
    azurerm_data_factory_linked_custom_service.adf_cosmosdb_linked_service,
    azurerm_data_factory_linked_service_kusto.kusto,
  ]

}
