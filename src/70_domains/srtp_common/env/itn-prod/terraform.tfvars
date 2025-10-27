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

law_daily_quota_gb                          = 100
cosmos_collections_autoscale_max_throughput = 1000

cosmos_otp_ttl = 120

# AKS
aks_nodepool_blue = {
  vm_sku_name    = "Standard_D4ads_v5_passive" # CHANGE in Standard_D4ads_v5_active when PROD is ready
  node_count_min = 0                           # CHANGE in 3 when PROD is ready
  node_count_max = 2
}

aks_nodepool_green = {
  vm_sku_name       = "Standard_D4ads_v5_passive"
  autoscale_enabled = false
  node_count_min    = 0
  node_count_max    = 0
}
