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
  # source = "./.terraform/modules/__v4__/IDH/subnet"

  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//IDH/subnet?ref=fix-subnet-container-app"


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

   resource "azurerm_subnet" "private_endpoint_cae_env_snet" {
       name                                          = "${local.project}-cae-private-endpoint-snet"
       resource_group_name                           = local.network_rg
       address_prefixes                              = [
           "10.10.4.0/28",
        ]
       default_outbound_access_enabled               = true
       private_endpoint_network_policies             = "Disabled"
       private_link_service_network_policies_enabled = true
       virtual_network_name                          = local.vnet_spoke_compute_name
    }

# module "private_endpoint_cae_env_snet" {
#   source = "./.terraform/modules/__v4__/IDH/subnet"
#
#   # General
#   product_name        = var.prefix
#   env                 = var.env
#   resource_group_name = local.network_rg
#
#   # Network
#   name                 = "${local.project}-cae-private-endpoint-snet"
#   virtual_network_name = local.vnet_spoke_compute_name
#
#   # IDH Resources
#   idh_resource_tier = "private_endpoint"
#
#   depends_on = [module.cae_env_snet]
# }

