locals {
  pipeline_templates = {
    for file in fileset("${path.module}/data_factory_pipelines", "*.json") :
    jsondecode(file("${path.module}/data_factory_pipelines/${file}")).name => jsondecode(file("${path.module}/data_factory_pipelines/${file}"))
  }

  # path to the trx report pipeline
  pipeline_trx_report_file = "${path.module}/data_factory_pipelines/templated/idpay_transaction_report.json"
  pipeline_trx_report_json = jsondecode(templatefile(local.pipeline_trx_report_file, {
    data_factory_api_base_url = var.data_factory_api_base_url
  }))
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

resource "azurerm_data_factory_pipeline" "idpay_transaction_report" {
  name            = local.pipeline_trx_report_json.name
  data_factory_id = data.azurerm_data_factory.data_factory.id

  description     = try(local.pipeline_trx_report_json.properties.description, null)
  concurrency     = try(local.pipeline_trx_report_json.properties.concurrency, null)
  annotations     = try(local.pipeline_trx_report_json.properties.annotations, [])
  parameters = try(
    {
      for k, v in local.pipeline_trx_report_json.properties.parameters :
      k => try(v.defaultValue, "")
    },
    {}
  )
  activities_json = jsonencode(local.pipeline_trx_report_json.properties.activities)
}
