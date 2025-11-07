locals {
  pipeline_templates = {
    for file in fileset("${path.module}/data_factory_pipelines", "*.json") :
    jsondecode(file("${path.module}/data_factory_pipelines/${file}")).name => jsondecode(file("${path.module}/data_factory_pipelines/${file}"))
  }
}

resource "azurerm_data_factory_pipeline" "pipelines" {
  for_each = local.pipeline_templates

  name            = each.key
  data_factory_id = data.azurerm_data_factory.data_factory.id
  annotations     = []

  parameters = try(
    { for k, v in each.value.properties.parameters : k => "" },
    {}
  )

  activities_json = jsonencode(each.value.properties.activities)

  depends_on = [
    azurerm_data_factory_custom_dataset.datasets
  ]
}
