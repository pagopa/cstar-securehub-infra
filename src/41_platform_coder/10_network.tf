module "aks_user_keycloak_snet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"

  # General
  product_name        = var.prefix
  env                 = var.env
  resource_group_name = local.vnet_network_rg_name

  # Network
  name                 = "${local.project}-keycloak-usr-snet"
  virtual_network_name = local.vnet_compute_name

  # IDH Resources
  idh_resource_tier = "aks_overlay"

  service_endpoints = []
}

resource "azurerm_subnet_nat_gateway_association" "nat_gateway_association" {
  subnet_id      = module.aks_user_keycloak_snet.id
  nat_gateway_id = data.azurerm_nat_gateway.compute_nat_gateway.id
}
