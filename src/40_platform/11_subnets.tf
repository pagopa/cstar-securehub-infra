#
# Network
#
module "synthetic_snet" {
  # source = "./.terraform/modules/__v4__/subnet"
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//subnet?ref=synthetic-improvements"

  name                 = "${local.project}-synthetic-snet"
  resource_group_name  = data.azurerm_virtual_network.vnet_platform.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet_platform.name
  address_prefixes     = var.cidr_subnet_synthetic_cae

  delegation = {
    name = "Microsoft.App/environments"
    service_delegation = {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

#
# Private endpoints
#
module "storage_private_endpoint_snet" {
  # source = "./.terraform/modules/__v3__/subnet"
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//subnet?ref=synthetic-improvements"

  resource_group_name  = data.azurerm_virtual_network.vnet_platform.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet_platform.name

  name             = "${local.project}-storage-private-endpoint-snet"
  address_prefixes = var.cidr_subnet_storage_private_endpoints

  service_endpoints = [
    "Microsoft.Storage",
  ]
}

module "container_app_private_endpoint_snet" {
  # source = "./.terraform/modules/__v3__/subnet"
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//subnet?ref=synthetic-improvements"

  resource_group_name  = data.azurerm_virtual_network.vnet_platform.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet_platform.name

  name             = "${local.project}-container-app-private-endpoint-snet"
  address_prefixes = var.cidr_subnet_container_app_private_endpoints

}
