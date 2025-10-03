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

#----------------------------------------------------------------
# 🔎 AKS Overlay Subnet
#----------------------------------------------------------------
module "aks_overlay_snet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"

  # General
  product_name        = var.prefix
  env                 = var.env
  resource_group_name = local.network_rg

  # Network
  name                 = "${local.project}-aks-${var.domain}-overlay-snet"
  virtual_network_name = local.vnet_spoke_compute_name

  # IDH Resources
  idh_resource_tier = "aks_overlay"
}

#----------------------------------------------------------------
# 🔎 DNS
#----------------------------------------------------------------
resource "azurerm_private_dns_a_record" "ingress" {
  name                = "${var.domain}.${var.location_short}"
  zone_name           = local.dns_zone_internal
  resource_group_name = local.vnet_legacy_core_rg
  ttl                 = 3600
  records             = [local.ingress_private_load_balancer_ip]
}

#----------------------------------------------------------------
# Nat Association for ALL created subnet in this folder
#----------------------------------------------------------------
resource "azurerm_subnet_nat_gateway_association" "nat_gateway_association" {
  for_each = {
    for snet in [module.cae_env_snet, module.aks_overlay_snet] : snet.name => snet
  }

  subnet_id      = each.value.id
  nat_gateway_id = data.azurerm_nat_gateway.compute_nat_gateway.id
}
