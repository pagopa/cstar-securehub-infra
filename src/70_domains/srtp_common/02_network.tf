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
