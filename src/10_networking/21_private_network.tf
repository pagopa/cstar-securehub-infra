#---------------------------------------------------------------------------
# Prometheus
#---------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "prometheus_dns_zone" {
  name                = "privatelink.${var.location}.prometheus.monitor.azure.com"
  resource_group_name = azurerm_resource_group.rg_network.name

  tags = module.tag_config.tags
}

#
# Virtual network link for workspace private dns zone
#
resource "azurerm_private_dns_zone_virtual_network_link" "prometheus_dns_zone_vnet_link" {
  for_each = { for i in local.vnets_all : i.name => i }

  name                  = "${each.key}-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_network.name
  private_dns_zone_name = azurerm_private_dns_zone.prometheus_dns_zone.name
  virtual_network_id    = each.value.id
}

#--------------------------------------------------------------------------------
# Storage Account - File
#--------------------------------------------------------------------------------

resource "azurerm_private_dns_zone" "file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_network.name

  tags = module.tag_config.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "file_private_endpoint_to_secure_hub_vnets" {
  for_each = { for i in local.vnets_all : i.name => i }

  name                  = "${each.key}-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_network.name
  private_dns_zone_name = azurerm_private_dns_zone.file.name
  virtual_network_id    = each.value.id
}

# ------------------------------------------------------------------------------
# Container apps private DNS zone
# ------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "container_app" {
  name                = "privatelink.${var.location}.azurecontainerapps.io"
  resource_group_name = azurerm_resource_group.rg_network.name

  tags = module.tag_config.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "container_app_private_endpoint_to_secure_hub_vnets" {
  for_each = { for i in local.vnets_all : i.name => i }

  name                  = "${each.key}-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_network.name
  private_dns_zone_name = azurerm_private_dns_zone.container_app.name
  virtual_network_id    = each.value.id
}

# ------------------------------------------------------------------------------
# Kusto private DNS zone
# ------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "kusto" {
  name                = "privatelink.${var.location}.kusto.windows.net"
  resource_group_name = azurerm_resource_group.rg_network.name

  tags = module.tag_config.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "kusto_private_endpoint_to_secure_hub_vnets" {
  for_each = { for i in local.vnets_all : i.name => i }

  name                  = "${each.key}-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg_network.name
  private_dns_zone_name = azurerm_private_dns_zone.kusto.name
  virtual_network_id    = each.value.id
}
