#
# Subnets SECURE-HUB
#

#
# Subnets HUB
#
# Azdoa
module "azdoa_snet" {
  source = "./.terraform/modules/__v4__/subnet"

  name                 = "${local.project}-hub-azdoa-snet"
  resource_group_name  = azurerm_resource_group.rg_network.name
  virtual_network_name = module.vnet_core_hub.name
  address_prefixes     = var.cidr_subnet_azdoa
}

#
# Subnets DATA
#
module "monitor_workspace_snet" {
  source = "./.terraform/modules/__v4__/subnet"

  name                 = "${local.project}-monitor-workspace-snet"
  resource_group_name  = azurerm_resource_group.rg_network.name
  virtual_network_name = module.vnet_spoke_data.name
  address_prefixes     = var.cidr_subnet_data_monitor_workspace
}
