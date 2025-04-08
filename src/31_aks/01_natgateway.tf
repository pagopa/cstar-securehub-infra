data "azurerm_public_ip" "compute_nat_gateway_pip" {
  name                = "${local.project}-compute-natgw-pip"
  resource_group_name = data.azurerm_virtual_network.vnet_compute_spoke.resource_group_name
}

data "azurerm_nat_gateway" "compute_nat_gateway" {
  name                = "${local.project}-compute-natgw"
  resource_group_name = data.azurerm_virtual_network.vnet_compute_spoke.resource_group_name
}

resource "azurerm_subnet_nat_gateway_association" "nat_gateway_association" {
  for_each = local.node_pool_subnet_list

  subnet_id      = each.value
  nat_gateway_id = data.azurerm_nat_gateway.compute_nat_gateway.id

  depends_on = [
    module.aks_snet,
  ]
}
