prefix         = "cstar"
env_short      = "p"
env            = "prod"
domain         = "mdc"
location       = "italynorth"
location_short = "itn"

# 🐳 Kubernetes
ingress_private_load_balancer_ip = "10.11.100.250"

# 🔎 DNS
external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.cstar"

redis_idh_tier = "standard_C1_v6"

aks_nodepool = {
  vm_sku_name       = "Standard_D8ads_v5_active"
  autoscale_enabled = true
  node_count_min    = 3
  node_count_max    = 5
}
