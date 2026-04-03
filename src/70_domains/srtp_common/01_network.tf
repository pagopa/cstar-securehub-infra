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
  idh_resource_tier = "slash28_privatelink_true"
  tags              = module.tag_config.tags
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
  tags              = module.tag_config.tags
}

#----------------------------------------------------------------
# 🔎 DNS
#----------------------------------------------------------------
# Ingress Private DNS A Record
resource "azurerm_private_dns_a_record" "ingress" {
  name                = "${var.domain}.${var.location_short}"
  zone_name           = local.dns_zone_internal
  resource_group_name = local.vnet_legacy_core_rg
  ttl                 = 3600
  records             = [local.ingress_private_load_balancer_ip]
  tags                = module.tag_config.tags
}
# Outbound out-rtp.cstar.pagopa.it
resource "azurerm_dns_a_record" "out_rtp" {
  name                = "out-rtp"
  zone_name           = local.dns_zone_name
  resource_group_name = local.vnet_legacy_core_rg
  ttl                 = 3600
  records             = [for i in data.azurerm_public_ip.nat_ips : i.ip_address]
  tags                = module.tag_config.tags
}

#----------------------------------------------------------------
# Nat Association
#----------------------------------------------------------------
resource "azurerm_subnet_nat_gateway_association" "nat_gateway_association" {
  for_each = {
    for snet in [module.aks_overlay_snet] : snet.name => snet
  }

  subnet_id      = each.value.id
  nat_gateway_id = data.azurerm_nat_gateway.compute_nat_gateway.id
}
