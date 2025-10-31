prefix         = "cstar"
env_short      = "p"
env            = "prod"
location       = "italynorth"
location_short = "itn"
domain         = "core"

#
# Dns
#
dns_zone_internal_prefix = "internal"
external_domain          = "pagopa.it"


default_zones = [1]

### Aks
# https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/482967553/AKS#sku-(dimensionamento)

aks_sku_tier                   = "Standard"
aks_private_cluster_is_enabled = true
aks_alerts_enabled             = false
aks_kubernetes_version         = "1.32.4"

# Standard is recommended tier Standard_D2ads_v5
# D – General purpose compute
# 2 – VM Size
# a – AMD-based processor
# d – Diskfull (local temp disk is present)
# s – Premium Storage capable
# v5 – version
aks_system_node_pool = {
  name                         = "system"
  vm_size                      = "Standard_D2ads_v5"
  os_disk_type                 = "Managed"
  os_disk_size_gb              = "64"
  node_count_min               = "3"
  node_count_max               = "6"
  only_critical_addons_enabled = true
  node_labels                  = { node_name : "aks-system-01", node_type : "system" },
  node_tags                    = { node_tag_1 : "1" },
}

#----------------------------------------------------------------
# AKS
#----------------------------------------------------------------
aks_nodepool_blue = {
  vm_sku_name       = "Standard_D4ads_v5_active"
  autoscale_enabled = true
  node_count_min    = 5
  node_count_max    = 12
}

aks_nodepool_green = {
  vm_sku_name       = "Standard_D4ads_v5_passive"
  autoscale_enabled = false
  node_count_min    = 0
  node_count_max    = 0
}

aks_cidr_subnet      = ["10.10.1.0/24"] # 10.10.1.0 -> 10.10.1.255
aks_cidr_subnet_user = ["10.10.2.0/24"] # 10.10.2.0 -> 10.10.2.255

ingress_min_replica_count = "10"
ingress_max_replica_count = "20"
ingress_load_balancer_ip  = "10.10.1.250"

# ingress-nginx helm charts releases 4.X.X: https://github.com/kubernetes/ingress-nginx/releases?expanded=true&page=1&q=tag%3Ahelm-chart-4
# Pinned versions from "4.12.1" release: https://github.com/kubernetes/ingress-nginx/releases/tag/helm-chart-4.12.1
nginx_helm = {
  version = "4.12.1"
  controller = {
    image = {
      registry     = "k8s.gcr.io"
      image        = "ingress-nginx/controller"
      tag          = "v1.12.1"
      digest       = "sha256:e5c4824e7375fcf2a393e1c03c293b69759af37a9ca6abdb91b13d78a93da8bd"
      digestchroot = "sha256:e0d4121e3c5e39de9122e55e331a32d5ebf8d4d257227cb93ab54a1b912a7627"
    },
    resources = {
      requests = {
        memory = "300Mi"
        cpu    = "200m"
      }
    },
    config = {
      proxy-body-size : 0,
    }
  }
}

# chart releases: https://github.com/kedacore/charts/releases
# keda image tags: https://github.com/kedacore/keda/pkgs/container/keda/versions
# keda-metrics-apiserver image tags: https://github.com/kedacore/keda/pkgs/container/keda-metrics-apiserver/versions
keda_helm_chart_version = "2.17.1"

# chart releases: https://github.com/stakater/Reloader/releases
# image tags: https://hub.docker.com/r/stakater/reloader/tags
reloader_helm = {
  chart_version = "v1.3.0"
  image_name    = "stakater/reloader"
  image_tag     = "v1.4.0@sha256:40e379c2b20350235aca2f0a43cc6f8a89397cef6869cb3a95db03390684390a"
}
