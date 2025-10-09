module "private_endpoint_cosmos_snet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"

  product_name        = var.prefix
  env                 = var.env
  resource_group_name = local.vnet_network_rg

  name                 = "${local.project}-cosmos-prv-end-snet"
  virtual_network_name = local.vnet_spoke_data_name

  idh_resource_tier = "private_endpoint"

  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.AzureCosmosDB"
  ]
}

module "private_endpoint_eventhub_snet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"

  product_name        = var.prefix
  env                 = var.env
  resource_group_name = local.vnet_network_rg

  name                 = "${local.project}-eventhub-prv-end-snet"
  virtual_network_name = local.vnet_spoke_data_name

  idh_resource_tier = "private_endpoint"

  service_endpoints = [
    "Microsoft.EventHub"
  ]
}

module "private_endpoint_storage_snet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"

  product_name        = var.prefix
  env                 = var.env
  resource_group_name = local.vnet_network_rg

  name                 = "${local.project}-storage-prv-end-snet"
  virtual_network_name = local.vnet_spoke_data_name

  idh_resource_tier = "private_endpoint"

  service_endpoints = [
    "Microsoft.Storage"
  ]
}

module "private_endpoint_redis_snet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"

  product_name        = var.prefix
  env                 = var.env
  resource_group_name = local.vnet_network_rg

  name                 = "${local.project}-redis-prv-end-snet"
  virtual_network_name = local.vnet_spoke_data_name

  idh_resource_tier = "private_endpoint"
}

resource "azurerm_private_dns_a_record" "ingress" {
  name                = "${var.domain}.${var.location_short}"
  zone_name           = data.azurerm_private_dns_zone.internal.name
  resource_group_name = local.internal_dns_zone_resource_group_name
  ttl                 = 3600
  records             = [var.ingress_private_load_balancer_ip]

  tags = local.tags
}
