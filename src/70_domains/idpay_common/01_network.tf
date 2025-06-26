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

  service_endpoints = [
    "Microsoft.AzureCosmosDB"
  ]
}

module "private_endpoint_eventhub_snet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"

  # General
  product_name        = var.prefix
  env                 = var.env
  resource_group_name = local.network_rg

  # Network
  name                 = "${local.project}-eventhub-prv-end-snet"
  virtual_network_name = local.vnet_spoke_data_name

  # IDH Resources
  idh_resource_tier = "private_endpoint"

  service_endpoints = [
    "Microsoft.EventHub"
  ]
}

module "private_endpoint_redis_snet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"

  # General
  product_name        = var.prefix
  env                 = var.env
  resource_group_name = local.network_rg

  # Network
  name                 = "${local.project}-redis-prv-end-snet"
  virtual_network_name = local.vnet_spoke_data_name

  # IDH Resources
  idh_resource_tier = "private_endpoint"
}


module "private_endpoint_storage_snet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"

  # General
  product_name        = var.prefix
  env                 = var.env
  resource_group_name = local.network_rg

  # Network
  name                 = "${local.project}-storage-prv-end-snet"
  virtual_network_name = local.vnet_spoke_data_name

  # IDH Resources
  idh_resource_tier = "private_endpoint"
}

module "private_endpoint_service_bus_snet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"
  count  = var.service_bus_namespace.sku == "Premium" ? 1 : 0

  # General
  product_name        = var.prefix
  env                 = var.env
  resource_group_name = local.network_rg

  # Network
  name                 = "${local.project}-serv-bus-prv-end-snet"
  virtual_network_name = local.vnet_spoke_data_name

  # IDH Resources
  idh_resource_tier = "private_endpoint"
}

# 🔎 DNS
resource "azurerm_private_dns_a_record" "ingress_idpay" {
  name                = "idpay.itn"
  zone_name           = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  resource_group_name = local.vnet_core_rg_name
  ttl                 = 3600
  records             = [local.ingress_private_load_balancer_ip]
}
