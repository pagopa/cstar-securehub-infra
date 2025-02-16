resource "azurerm_resource_group" "rg_network" {
  name     = "${local.project}-network-rg"
  location = var.location

  tags = var.tags
}

#
# Vnet
#

module "vnet_core_hub" {
  source = "./.terraform/modules/__v4__/virtual_network"

  name                = "${local.project}-hub-vnet"
  location            = azurerm_resource_group.rg_network.location
  resource_group_name = azurerm_resource_group.rg_network.name
  address_space       = var.cidr_core_hub_vnet

  tags = var.tags
}

#
# SPOKES
#
module "vnet_spoke_platform_core" {
  source = "./.terraform/modules/__v4__/virtual_network"

  name                = "${local.project}-spoke-platform-vnet"
  location            = azurerm_resource_group.rg_network.location
  resource_group_name = azurerm_resource_group.rg_network.name
  address_space       = var.cidr_spoke_platform_core_vnet

  tags = var.tags
}
