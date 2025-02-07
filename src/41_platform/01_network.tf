module "postgres_flexible_snet" {
  source = "./.terraform/modules/__v3__/subnet"

  name                                          = "${local.project}-postgres-flexible-snet"
  address_prefixes                              = var.cidr_postgres_subnet
  resource_group_name                           = data.azurerm_virtual_network.vnet_core.resource_group_name
  virtual_network_name                          = data.azurerm_virtual_network.vnet_core.name
  service_endpoints                             = ["Microsoft.Storage"]
  private_link_service_network_policies_enabled = true

  delegation = {
    name = "delegation"
    service_delegation = {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}
