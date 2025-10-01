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

resource "azurerm_private_endpoint" "kusto" {
  name                = "${azurerm_kusto_cluster.data_explorer_cluster.name}-prv-endpoint-kusto"
  location            = azurerm_kusto_cluster.data_explorer_cluster.location
  resource_group_name = azurerm_kusto_cluster.data_explorer_cluster.resource_group_name
  subnet_id           = module.adx_snet.subnet_id

  private_service_connection {
    name                           = "${azurerm_kusto_cluster.data_explorer_cluster.name}-private-endpoint-kusto"
    private_connection_resource_id = azurerm_kusto_cluster.data_explorer_cluster.id
    is_manual_connection           = false
    subresource_names              = ["cluster"]
  }
  tags = module.tag_config.tags
}

resource "azurerm_private_dns_a_record" "kusto_record" {
  name                = azurerm_kusto_cluster.data_explorer_cluster.name
  zone_name           = data.azurerm_private_dns_zone.kusto.name
  resource_group_name = data.azurerm_private_dns_zone.kusto.resource_group_name
  records             = [azurerm_private_endpoint.kusto.private_service_connection[0].private_ip_address]
  ttl                 = 300

  tags = module.tag_config.tags
}

resource "azurerm_kusto_cluster_principal_assignment" "grafana_viewer" {
  name                = "${local.project}-grafana-viewer"
  resource_group_name = azurerm_kusto_cluster.data_explorer_cluster.resource_group_name
  cluster_name        = azurerm_kusto_cluster.data_explorer_cluster.name

  tenant_id      = data.azurerm_client_config.current.tenant_id
  principal_id   = azurerm_dashboard_grafana.grafana_managed.identity[0].principal_id
  principal_type = "App"
  role           = "AllDatabasesViewer"
}
