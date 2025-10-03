# general
prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "srtp"
location       = "italynorth"
location_short = "itn"
cdn_location   = "westeurope"

# this is the deafult value for tenant pagopa.it
azuread_service_principal_azure_cdn_frontdoor_id = "f3b3f72f-4770-47a5-8c1e-aa298003be12"
enable_cdn                                       = true

law_daily_quota_gb                          = 5
cosmos_collections_autoscale_max_throughput = 1000

# AKS
aks_user_nodepool = {
  vm_sku_name       = "Standard_D8ads_v5_active"
  autoscale_enabled = true
  node_count_min    = 1
  node_count_max    = 1 # 3
}
