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

# 🤖 Robots
robots_indexed_paths = []

# CDN
backoffice_cdn_storage_replication_type = "LRS"

# Redis
redis_idh_tier = "basic"

#Monitoring
law_sku                                = "PerGB2018"
law_retention_in_days                  = 30
law_daily_quota_gb                     = 15
audit_export_enabled                   = true
audit_logs_retention_days              = 180
audit_storage_account_replication_type = "ZRS"
audit_storage_account_tier             = "basic_audit_cool"

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
