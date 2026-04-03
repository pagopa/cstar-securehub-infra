prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "mdc"
location       = "italynorth"
location_short = "itn"

# 🔎 DNS
external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.uat.cstar"
dns_zone_public_name     = "uat.cstar.pagopa.it"

# Redis
redis_idh_tier = "basic"

#Monitoring
law_sku               = "PerGB2018"
law_retention_in_days = 30
law_daily_quota_gb    = 15

aks_nodepool = {
  vm_sku_name       = "Standard_D4ads_v5_active"
  autoscale_enabled = true
  node_count_min    = 1
  node_count_max    = 2
}

cosmos_mongodb_common_configuration = {
  max_throughput    = 1000
  autoscale_enabled = true
}
