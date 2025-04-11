resource "azurerm_public_ip" "messagi_cortesia_pips" {

  for_each = toset(["alfa"])

  name                = "${local.project}-mc-${each.key}-pip"
  resource_group_name = azurerm_resource_group.rg_network.name
  location            = azurerm_resource_group.rg_network.location
  sku                 = "Standard"
  allocation_method   = "Static"

  tags = local.tags_for_mc
}

resource "azurerm_public_ip" "compute_nat_gateway_pip" {
  name                = "${local.project}-compute-natgw-pip"
  location            = azurerm_resource_group.rg_network.location
  resource_group_name = azurerm_resource_group.rg_network.name
  allocation_method   = "Static"
  zones               = var.default_zones
}
