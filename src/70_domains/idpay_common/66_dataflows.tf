locals {
  dataflow_templates = {
    for file in fileset("${path.module}/data_factory_dataflows", "*.json") :
    jsondecode(file("${path.module}/data_factory_dataflows/${file}")).name
    => jsondecode(file("${path.module}/data_factory_dataflows/${file}"))
  }

  dataflow_sources = {
    for k, v in local.dataflow_templates :
    k => try([
      for s in v.properties.typeProperties.sources : {
        name    = s.name
        dataset = s.dataset.referenceName
      }
    ], [])
  }

  dataflow_sinks = {
    for k, v in local.dataflow_templates :
    k => try([
      for s in v.properties.typeProperties.sinks : {
        name    = s.name
        dataset = s.dataset.referenceName
      }
    ], [])
  }

  dataflow_transformations = {
    for k, v in local.dataflow_templates :
    k => try([for t in v.properties.typeProperties.transformations : t.name], [])
  }
}

resource "azurerm_data_factory_data_flow" "dataflows" {
  for_each        = local.dataflow_templates
  name            = each.key
  data_factory_id = data.azurerm_data_factory.data_factory.id

  script = join("\n", compact(try(each.value.properties.typeProperties.scriptLines, [])))

  dynamic "source" {
    for_each = try(local.dataflow_sources[each.key], [])
    content {
      name = source.value.name
      dataset { name = source.value.dataset }
    }
  }

  dynamic "transformation" {
    for_each = try(local.dataflow_transformations[each.key], [])
    content {
      name = transformation.value
    }
  }

  dynamic "sink" {
    for_each = try(local.dataflow_sinks[each.key], [])
    content {
      name = sink.value.name
      dataset { name = sink.value.dataset }
    }
  }

  # <<<— static lists of resource
  depends_on = [
    azurerm_data_factory_custom_dataset.datasets,
    azurerm_data_factory_linked_custom_service.adf_cosmosdb_linked_service,
    azurerm_data_factory_linked_service_kusto.kusto
  ]
}
