locals {
  pipeline_templates = {
    for file in fileset("${path.module}/data_factory_pipeline", "*.json") :
    trimsuffix(file, ".json") => jsondecode(file("${path.module}/pipeline_templates/${file}"))
  }
}

resource "azurerm_data_factory_pipeline" "pipelines" {
  for_each = local.pipeline_templates

  name            = each.value.name
  data_factory_id = data.azurerm_data_factory.data_factory.id
  annotations     = []

  activities_json = jsonencode(each.value.properties.activities)
}
