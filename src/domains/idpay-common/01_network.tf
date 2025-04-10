module "idpay_cosmosdb_snet" {
  source = "./.terraform/modules/__v4__/subnet"

  name                 = "${local.project}-cosmosdb-snet"
  virtual_network_name = local.vnet_spoke_data_name
  resource_group_name  = local.vnet_spoke_data_rg_name
  address_prefixes     = var.cidr_idpay_data_cosmos
}

module "idpay_eventhub_snet" {
  source = "./.terraform/modules/__v4__/subnet"

  name                 = "${local.project}-eventhub-snet"
  virtual_network_name = local.vnet_spoke_data_name
  resource_group_name  = local.vnet_spoke_data_rg_name
  address_prefixes     = var.cidr_idpay_data_eventhub
}

module "idpay_redis_snet" {
  source = "./.terraform/modules/__v4__/subnet"

  name                 = "${local.project}-redis-snet"
  virtual_network_name = local.vnet_spoke_data_name
  resource_group_name  = local.vnet_spoke_data_rg_name
  address_prefixes     = var.cidr_idpay_data_redis
}
