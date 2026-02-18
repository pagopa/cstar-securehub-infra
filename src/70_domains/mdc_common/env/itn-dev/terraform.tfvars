prefix         = "cstar"
env_short      = "d"
env            = "dev"
domain         = "mdc"
location       = "italynorth"
location_short = "itn"

# 🐳 Kubernetes
ingress_private_load_balancer_ip = "10.10.1.250"

# 🔎 DNS
external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.dev.cstar"

#Monitoring
law_sku               = "PerGB2018"
law_retention_in_days = 30
law_daily_quota_gb    = 5

# Redis
redis_idh_tier = "basic"

aks_nodepool = {
  vm_sku_name       = "Standard_B4ms_active"
  autoscale_enabled = true
  node_count_min    = 1
  node_count_max    = 2
}
