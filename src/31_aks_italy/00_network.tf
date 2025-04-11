#
# Compute spoke VNET
#
data "azurerm_resource_group" "vnet_compute_spoke_rg" {
  name = "${local.project}-network-rg"
}

data "azurerm_virtual_network" "vnet_compute_spoke" {
  name                = "${local.project}-spoke-compute-vnet"
  resource_group_name = data.azurerm_resource_group.vnet_compute_spoke_rg.name
}
