prefix         = "cstar"
env_short      = "p"
env            = "prod"
domain         = "mdc"
location       = "italynorth"
location_short = "itn"

# 🔎 DNS
external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.cstar"

redis_idh_tier = "standard_C1_v6"

#Monitoring
law_sku               = "PerGB2018"
law_retention_in_days = 30
law_daily_quota_gb    = 100

aks_nodepool = {
  vm_sku_name       = "Standard_D8ads_v5_active"
  autoscale_enabled = true
  node_count_min    = 2
  node_count_max    = 4
}

cosmos_mongodb_common_configuration = {
  max_throughput    = 10000
  autoscale_enabled = true
}

### CosmosDB
additional_geo_locations = [{
  location          = "germanywestcentral"
  failover_priority = 1
  zone_redundant    = false
}]
