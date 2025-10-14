locals {

  dataset_templates = {
    for file in fileset("${path.module}/data_factory_datasets", "*.json") :
    jsondecode(file("${path.module}/data_factory_datasets/${file}")).name => jsondecode(file("${path.module}/data_factory_datasets/${file}"))
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

  description = lookup(each.value, "description", null)
  annotations = lookup(each.value, "annotations", [])

  parameters  = lookup(each.value, "parameters", null)
  schema_json = lookup(each.value, "schema", null)

  depends_on = [
    azurerm_data_factory_linked_custom_service.adf_cosmosdb_linked_service,
    azurerm_data_factory_linked_service_kusto.kusto,
  ]

}
