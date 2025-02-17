# resource "azurerm_public_ip" "mc_public_ip" {
#   name                = "${local.project}-mc-nat-pip"
#   resource_group_name = azurerm_resource_group.rg_network.name
#   location            = azurerm_resource_group.rg_network.location
#   sku                 = "Standard"
#   allocation_method   = "Static"
#
#   tags = local.tags_for_mc
# }
