# general
prefix         = "cstar"
env_short      = "p"
env            = "prod"
domain         = "srtp"
location       = "italynorth"
location_short = "itn"
cdn_location   = "westeurope"

# this is the deafult value for tenant pagopa.it
azuread_service_principal_azure_cdn_frontdoor_id = "f3b3f72f-4770-47a5-8c1e-aa298003be12"
enable_cdn                                       = false

law_daily_quota_gb = 100
# Activation database - shared throughput at database level (4000 RU)
cosmos_activation_db_autoscale_max_throughput = 20000

# RTP database - shared throughput at database level (1000 RU)
cosmos_rtp_db_autoscale_max_throughput = 10000

# Payee database - shared throughput at database level
cosmos_payee_db_autoscale_max_throughput = 1000

cosmos_otp_ttl = 3600

# AKS
aks_nodepool_blue = {
  vm_sku_name       = "Standard_D4ads_v5_passive" # CHANGE in Standard_D4ads_v5_active when PROD is ready
  autoscale_enabled = false
  node_count_min    = 0 # CHANGE in 3 when PROD is ready
  node_count_max    = 0
}

aks_nodepool_green = {
  vm_sku_name       = "Standard_D4ads_v5_active"
  autoscale_enabled = true
  node_count_min    = 3
  node_count_max    = 4
}

### CosmosDB
additional_geo_locations = [{
  location          = "germanywestcentral"
  failover_priority = 1
  zone_redundant    = false
}]

### Redis Cache
redis_idh_resource_tier = "standard_C1_v6"

### ADX
adx_db_soft_delete_period_days    = 15
adx_db_hot_cache_period_days      = 5
adx_table_soft_delete_period_days = 3650
adx_table_hot_cache_period_days   = 30
