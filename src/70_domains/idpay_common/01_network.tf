module "idpay_cosmosdb_snet" {
  source = "./.terraform/modules/__v4__/subnet"

  name                 = "${local.project}-cosmosdb-snet"
  virtual_network_name = local.vnet_spoke_data_name
  resource_group_name  = local.vnet_spoke_data_rg_name
  address_prefixes     = var.cidr_idpay_data_cosmos

  service_endpoints = [
    "Microsoft.AzureCosmosDB"
  ]
}

module "idpay_eventhub_snet" {
  source = "./.terraform/modules/__v4__/subnet"
  # source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//subnet?ref=PAYMCLOUD-344-v-4-event-hub-revisione-modulo-v-4"

  name                 = "${local.project}-eventhub-snet"
  virtual_network_name = local.vnet_spoke_data_name
  resource_group_name  = local.vnet_spoke_data_rg_name
  address_prefixes     = var.cidr_idpay_data_eventhub

  service_endpoints = [
    "Microsoft.EventHub"
  ]
}

module "idpay_redis_snet" {
  source = "./.terraform/modules/__v4__/subnet"

  name                 = "${local.project}-redis-snet"
  virtual_network_name = local.vnet_spoke_data_name
  resource_group_name  = local.vnet_spoke_data_rg_name
  address_prefixes     = var.cidr_idpay_data_redis
}

module "idpay_storage_snet" {
  source = "./.terraform/modules/__v4__/subnet"

  name                 = "${local.project}-storage-snet"
  virtual_network_name = local.vnet_spoke_data_name
  resource_group_name  = local.vnet_spoke_data_rg_name
  address_prefixes     = var.cidr_idpay_data_storage
}

# 🔎 DNS
resource "azurerm_private_dns_a_record" "ingress_idpay" {
  name                = "idpay.itn"
  zone_name           = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  resource_group_name = local.vnet_core_rg_name
  ttl                 = 3600
  records             = [local.ingress_private_load_balancer_ip]
}
