
resource "azurerm_nat_gateway" "compute_nat_gateway" {
  name                    = "${local.project}-compute-natgw"
  location                = azurerm_resource_group.rg_network.location
  resource_group_name     = azurerm_resource_group.rg_network.name
  sku_name                = var.nat_sku
  idle_timeout_in_minutes = var.nat_idle_timeout_in_minutes
  zones                   = var.default_zones

  tags = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "compute_nat_gateway_pip_association" {
  nat_gateway_id       = azurerm_nat_gateway.compute_nat_gateway.id
  public_ip_address_id = azurerm_public_ip.compute_nat_gateway_pip.id
}
