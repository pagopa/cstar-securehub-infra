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
