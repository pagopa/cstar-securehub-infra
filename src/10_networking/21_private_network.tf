



#
# Prometheus
#

# Create workspace private DNS zone
resource "azurerm_private_dns_zone" "prometheus_dns_zone" {
  name                = "privatelink.${var.location}.prometheus.monitor.azure.com"
  resource_group_name = azurerm_resource_group.rg_network.name
}

#
# Virtual network link for workspace private dns zone
#
resource "azurerm_private_dns_zone_virtual_network_link" "prometheus_dns_zone_vnet_link_data" {
  name                  = module.vnet_spoke_data.name
  resource_group_name   = azurerm_resource_group.rg_network.name
  virtual_network_id    = module.vnet_spoke_data.id
  private_dns_zone_name = azurerm_private_dns_zone.prometheus_dns_zone.name
}
