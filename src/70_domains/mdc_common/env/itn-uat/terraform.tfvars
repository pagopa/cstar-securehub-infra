prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "mdc"
location       = "italynorth"
location_short = "itn"

# 🐳 Kubernetes
ingress_private_load_balancer_ip = "10.11.100.250"

# 🔎 DNS
external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.uat.cstar"

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
