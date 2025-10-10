prefix             = "cstar"
env_short          = "u"
env                = "uat"
domain             = "idpay"
location           = "italynorth"
location_short     = "itn"
location_weu       = "westeurope"
location_short_weu = "weu"

#
# Dns
#
dns_zone_prefix          = "uat.cstar"
dns_zone_internal_prefix = "internal.uat.cstar"
external_domain          = "pagopa.it"

cosmos_mongo_db_idpay_params = {
  throughput     = null
  max_throughput = 1000
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
ehns_auto_inflate_enabled     = true
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
idpay_cdn_storage_account_replication_type            = "ZRS"
selfcare_welfare_cdn_storage_account_replication_type = "ZRS"
robots_indexed_paths                                  = []
single_page_applications_roots_dirs = [
  "portale-enti",
  "portale-esercenti",
  "mocks/merchant",
  "ricevute"
]

single_page_applications_asset_register_roots_dirs = [
  "elenco-informatico-elettrodomestici"
]

single_page_applications_portal_merchants_operator_roots_dirs = [
  "portale-esercenti"
]

#----------------------------------------------------------------
# AKS
#----------------------------------------------------------------
aks_nodepool_blue = {
  vm_sku_name       = "Standard_D8ads_v5_active"
  autoscale_enabled = true
  node_count_min    = 1
  node_count_max    = 3
}

aks_nodepool_green = {
  vm_sku_name       = "Standard_D8ads_v5_passive"
  autoscale_enabled = false
  node_count_min    = 0
  node_count_max    = 0
}

#Monitoring
law_sku                     = "PerGB2018"
law_retention_in_days       = 30
law_daily_quota_gb          = 15

#OneIdentity
oneidentity_base_url = "https://uat.oneid.pagopa.it"
