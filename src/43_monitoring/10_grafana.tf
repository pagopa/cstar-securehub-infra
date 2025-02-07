resource "azurerm_resource_group" "grafana_rg" {
  name     = "${local.project}-grafana-rg"
  location = var.location

  tags = var.tags
}
#
# 📊 Grafana Managed
#
resource "azurerm_dashboard_grafana" "grafana_dashboard" {
  name                              = "${local.product}-${var.location_short_westeurope}-grafana"
  resource_group_name               = azurerm_resource_group.grafana_rg.name
  location                          = var.location_westeurope
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = false
  zone_redundancy_enabled           = var.grafana_zone_redundancy_enabled
  grafana_major_version             = var.grafana_major_version
  sku                               = "Standard"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "grafana_dashboard_monitoring_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.grafana_dashboard.identity[0].principal_id
}
