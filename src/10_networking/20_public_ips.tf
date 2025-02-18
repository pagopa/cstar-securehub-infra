resource "azurerm_public_ip" "messagi_cortesia_pips" {

  for_each = toset(["alfa"])

  name                = "${local.project}-mc-${each.key}-pip"
  resource_group_name = azurerm_resource_group.rg_network.name
  location            = azurerm_resource_group.rg_network.location
  sku                 = "Standard"
  allocation_method   = "Static"

  tags = local.tags_for_mc
}
