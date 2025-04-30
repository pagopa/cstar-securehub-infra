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
