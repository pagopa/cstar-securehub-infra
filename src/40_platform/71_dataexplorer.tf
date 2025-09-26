resource "azurerm_kusto_cluster" "data_explorer_cluster" {
  name                = local.project
  location            = var.location
  resource_group_name = module.default_resource_groups[var.domain].resource_group_names["data"]

  auto_stop_enabled           = false
  streaming_ingestion_enabled = true

  sku {
    name     = var.data_explorer_config.sku.name
    capacity = var.data_explorer_config.sku.capacity
  }

  dynamic "optimized_auto_scale" {
    for_each = var.data_explorer_config.autoscale.enabled ? [1] : []

    content {
      minimum_instances = var.data_explorer_config.autoscale.min_instances
      maximum_instances = var.data_explorer_config.autoscale.max_instances
    }
  }

  identity {
    type = "SystemAssigned"
  }

  public_network_access_enabled = var.data_explorer_config.public_network_access_enabled
  double_encryption_enabled     = var.data_explorer_config.double_encryption_enabled

  tags = module.tag_config.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
