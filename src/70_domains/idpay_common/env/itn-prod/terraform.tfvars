prefix             = "cstar"
env_short          = "p"
env                = "prod"
domain             = "idpay"
location           = "italynorth"
location_short     = "itn"
location_weu       = "westeurope"
location_short_weu = "weu"

#
# Dns
#
dns_zone_prefix          = "cstar"
dns_zone_internal_prefix = "internal.cstar"

external_domain = "pagopa.it"

#
# CIDRs
#
cidr_idpay_data_eventhub = ["10.20.10.32/27"] # 10.20.10.32 -> 10.20.10.63
cidr_idpay_data_redis    = ["10.20.10.64/27"] # 10.20.10.64 -> 10.20.10.95
cidr_idpay_data_storage  = ["10.20.10.96/27"] # 10.20.10.96 -> 10.20.10.127

cosmos_mongo_db_idpay_params = {
  throughput     = null
  max_throughput = 1000
}

#
# Service bus
#
service_bus_namespace = {
  sku = "Premium"
}

##Eventhub
ehns_sku_name                 = "Standard"
ehns_capacity                 = 5
ehns_maximum_throughput_units = 5
ehns_auto_inflate_enabled     = true
ehns_alerts_enabled           = true

### handle resource enable
enable = {
  idpay = {
    eventhub_idpay_00 = true
    eventhub_idpay_01 = false
    eventhub_rdb      = true
  }
}

### CDN
idpay_cdn_storage_account_replication_type            = "ZRS"
selfcare_welfare_cdn_storage_account_replication_type = "ZRS"
idpay_cdn_sa_advanced_threat_protection_enabled       = true
single_page_applications_roots_dirs = [
  "portale-enti",
  "portale-esercenti",
  "mocks/merchant",
  "ricevute"
]

single_page_applications_asset_register_roots_dirs = [
  "registro-dei-beni"
]
