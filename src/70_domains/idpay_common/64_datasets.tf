locals {
  dataset_templates = {
    for file in fileset("${path.module}/data_factory_dataset", "*.json") :
    trimsuffix(file, ".json") => jsondecode(file("${path.module}/dataset_templates/${file}"))
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
