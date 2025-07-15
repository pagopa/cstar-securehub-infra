module "private_endpoint_cosmos_snet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"

  # General
  product_name        = var.prefix
  env                 = var.env
  resource_group_name = local.network_rg

  # Network
  name                 = "${local.project}-cosmos-prv-end-snet"
  virtual_network_name = local.vnet_spoke_data_name

  # IDH Resources
  idh_resource_tier = "private_endpoint"
}

module "private_endpoint_storage_account_snet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"

  # General
  product_name        = var.prefix
  env                 = var.env
  resource_group_name = local.network_rg

  # Network
  name                 = "${local.project}-storage-account-prv-end-snet"
  virtual_network_name = local.vnet_spoke_data_name

  # IDH Resources
  idh_resource_tier = "private_endpoint"
}

#---------------------------------------------------------------
# CAE Environment and Private Endpoint Subnets
#---------------------------------------------------------------
module "cae_env_snet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"
  # source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//IDH/subnet?ref=fix-subnet-container-app"

  # General
  product_name        = var.prefix
  env                 = var.env
  resource_group_name = local.network_rg

  # Network
  name                 = "${local.project}-cae-snet"
  virtual_network_name = local.vnet_spoke_compute_name

  # IDH Resources
  idh_resource_tier = "container_app_environment"
}

module "private_endpoint_cae_snet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"

  # General
  product_name        = var.prefix
  env                 = var.env
  resource_group_name = local.network_rg

  # Network
  name                 = "${local.project}-cae-prv-end-snet"
  virtual_network_name = local.vnet_spoke_compute_name

  # IDH Resources
  idh_resource_tier = "private_endpoint"
}

#
# NAT Gateway
#
resource "azurerm_subnet_nat_gateway_association" "nat_gateway_association" {
  subnet_id      = module.cae_env_snet.id
  nat_gateway_id = data.azurerm_nat_gateway.compute_nat_gateway.id

  depends_on = [
    module.cae_env_snet,
  ]
}
