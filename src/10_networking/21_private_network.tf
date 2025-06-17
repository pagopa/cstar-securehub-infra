#
# Prometheus
#

# Create workspace private DNS zone
resource "azurerm_private_dns_zone" "prometheus_dns_zone" {
  name                = "privatelink.${var.location}.prometheus.monitor.azure.com"
  resource_group_name = azurerm_resource_group.rg_network.name

  tags = module.tag_config.tags
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

#
# Storage Account - File
#

resource "azurerm_private_dns_zone" "file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_network.name

  tags = module.tag_config.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "file_private_endpoint_to_secure_hub_vnets" {
  for_each = {
    for i in toset([module.vnet_core_hub, module.vnet_spoke_data, module.vnet_spoke_compute, module.vnet_spoke_security]) : i.name => i
  }

  name                  = "${each.key}-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_network.name
  private_dns_zone_name = azurerm_private_dns_zone.file.name
  virtual_network_id    = each.value.id
}
