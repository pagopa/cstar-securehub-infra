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
# Subnet
#

# # Azdoa
# module "azdoa_snet" {
#   source = "./.terraform/modules/__v3__/subnet"
#   count  = var.enable_azdoa ? 1 : 0
#
#   name                                      = "${local.project}-azdoa-snet"
#   resource_group_name                       = azurerm_resource_group.rg_vnet.name
#   virtual_network_name                      = module.vnet_core.name
#   address_prefixes                          = var.cidr_subnet_azdoa
#   private_endpoint_network_policies_enabled = true
# }
