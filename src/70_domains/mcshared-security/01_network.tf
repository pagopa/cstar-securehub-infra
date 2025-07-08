module "private_endpoint_kv_snet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"

  # General
  product_name        = var.prefix
  env                 = var.env
  resource_group_name = local.vnet_core_rg_name

  # Network
  name                 = "${local.project}-kv-prv-end-snet"
  virtual_network_name = local.vnet_spoke_security_name

  # IDH Resources
  idh_resource_tier = "private_endpoint"
}
