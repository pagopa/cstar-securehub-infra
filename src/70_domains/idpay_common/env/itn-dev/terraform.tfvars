prefix             = "cstar"
env_short          = "d"
env                = "dev"
domain             = "idpay"
location           = "italynorth"
location_short     = "itn"
location_weu       = "westeurope"
location_short_weu = "weu"

#
# Dns
#
dns_zone_prefix          = "dev.cstar"
dns_zone_internal_prefix = "internal.dev.cstar"
external_domain          = "pagopa.it"

cosmos_mongo_db_idpay_params = {
  throughput     = null
  max_throughput = null
}

#
# Service bus
#
service_bus_namespace = {
  sku = "Standard"
}

##Eventhub
ehns_sku_name                 = "Standard"
ehns_capacity                 = 1
ehns_maximum_throughput_units = 5
ehns_auto_inflate_enabled     = false
ehns_alerts_enabled           = false

### handle resource enable
enable = {
  idpay = {
    eventhub_idpay_00 = true
    eventhub_idpay_01 = true
    eventhub_rdb      = true
  }
}

### CDN
idpay_cdn_storage_account_replication_type            = "LRS"
selfcare_welfare_cdn_storage_account_replication_type = "LRS"
robots_indexed_paths                                  = []
idpay_cdn_sa_advanced_threat_protection_enabled       = false
single_page_applications_roots_dirs = [
  "portale-enti",
  "portale-esercenti",
  "mocks/merchant",
  "ricevute"
]

single_page_applications_asset_register_roots_dirs = [
  "registro-dei-beni"
]
