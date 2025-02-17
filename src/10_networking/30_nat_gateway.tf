# resource "azurerm_nat_gateway" "mc_nat_gateway" {
#   name                = "${local.project}-mc-natgw"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.rg_network.name
#   sku_name            = "Standard"
#
#   idle_timeout_in_minutes = var.nat_idle_timeout_in_minutes
#
#   tags = local.tags_for_mc
# }
#
# resource "azurerm_nat_gateway_public_ip_association" "mc_nat_gateway_public_ip_association" {
#   nat_gateway_id       = azurerm_nat_gateway.mc_nat_gateway.id
#   public_ip_address_id = azurerm_public_ip.mc_public_ip.id
# }
