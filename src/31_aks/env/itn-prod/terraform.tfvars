# general
prefix         = "cstar"
env_short      = "p"
env            = "prod"
domain         = "prod"
location       = "italynorth"
location_short = "itn"

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

#
# Subnets
#

aks_cidr_system_subnet = ["10.1.0.0/24"]
aks_cidr_user_subnet   = ["10.1.1.0/24"]

#
# AKS
#

aks_kubernetes_version = "1.29.7"

# https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/482967553/AKS#sku-(dimensionamento)
aks_sku_tier       = "Standard"
aks_alerts_enabled = true

aks_system_node_pool = {
  name                         = "cstarpsys"
  vm_size                      = "Standard_D2ds_v5"
  os_disk_type                 = "Ephemeral"
  os_disk_size_gb              = "75"
  node_count_min               = "1"
  node_count_max               = "2"
  only_critical_addons_enabled = true
  node_labels                  = { node_name : "aks-system-01", node_type : "system" },
  node_tags                    = { node_tag_1 : "1" },
}

aks_user_node_pool_standalone = {
  enabled         = true,
  name            = "cstarpuser01",
  vm_size         = "Standard_B8ms",
  os_disk_type    = "Managed",
  os_disk_size_gb = 75,
  node_count_min  = 1,
  node_count_max  = 1,
  node_labels     = { node_name : "aks-prod01-user", node_type : "user" },
  node_taints     = [],
  node_tags       = { node_tag_2 : "2" },
}

nginx_ingress_helm_version = "4.11.1"

# chart releases: https://github.com/kedacore/charts/releases
keda_helm_chart_version = "2.14.3"

#
# Dns
#
dns_zone_internal_prefix = "internal"
external_domain          = "pagopa.it"

### ARGOCD
#https://github.com/argoproj/argo-helm/releases/tag/argo-cd-7.7.7
argocd_helm_release_version = "7.7.7" #2.13.1
