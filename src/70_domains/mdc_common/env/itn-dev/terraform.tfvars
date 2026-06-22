prefix         = "cstar"
env_short      = "d"
env            = "dev"
domain         = "mdc"
location       = "italynorth"
location_short = "itn"

# 🔎 DNS
external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.dev.cstar"
dns_zone_public_name     = "dev.cstar.pagopa.it"

# 🤖 Robots
robots_indexed_paths = []

# CDN
backoffice_cdn_storage_replication_type = "LRS"

#Monitoring
law_sku               = "PerGB2018"
law_retention_in_days = 30
law_daily_quota_gb    = 5
# In dev non serve il debug storico esteso: solo i 90 gg interactive gratuiti, nessun Archive a pagamento.
app_insights_trace_total_retention_in_days = 90

# Redis
redis_idh_tier = "basic"

aks_nodepool = {
  vm_sku_name       = "Standard_B4ms_active"
  autoscale_enabled = true
  node_count_min    = 1
  node_count_max    = 2
}

cosmos_mongodb_common_configuration = {
  max_throughput    = 1000
  autoscale_enabled = false
}
