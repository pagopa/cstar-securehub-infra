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
law_sku               = "PerGB2018"
law_retention_in_days = 30
law_daily_quota_gb    = 15
# In uat non serve il debug storico esteso: solo i 90 gg interactive gratuiti, nessun Archive a pagamento.
app_insights_trace_total_retention_in_days = 90

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
