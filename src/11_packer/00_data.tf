data "azurerm_resource_group" "vnet_rg" {
  name = "${local.product_nodomain}-core-vnet-rg"
}
