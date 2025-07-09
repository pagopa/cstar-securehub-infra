## General
variable "prefix" {
  type = string
  validation {
    condition = (
      length(var.prefix) <= 6
    )
    error_message = "Max length is 6 chars."
  }
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "env_short" {
  type = string
  validation {
    condition = (
      length(var.env_short) <= 1
    )
    error_message = "Max length is 1 chars."
  }
}

variable "location" {
  type = string
}

variable "location_short" {
  type        = string
  description = "Location short like eg: neu, weu.."
}

# variable "pagopa_location_short" {
#   type        = string
#   description = "Pagopa's location short like eg: weu.."
# }

variable "domain" {
  type = string
  validation {
    condition = (
      length(var.domain) <= 12
    )
    error_message = "Max length is 12 chars."
  }
}

#
# DNS
#
variable "dns_zone_internal_prefix" {
  type        = string
  default     = null
  description = "The dns subdomain."
}

variable "external_domain" {
  type        = string
  description = "Domain for delegation"
}

variable "default_zones" {
  type        = list(number)
  description = "List of zones in which the scale set will be deployed"
  default     = [1, 2, 3]
}

### Aks

variable "aks_private_cluster_is_enabled" {
  type        = bool
  description = "Allow to configure the AKS, to be setup as a private cluster. To reach it, you need to use an internal VM or VPN"
}

variable "aks_alerts_enabled" {
  type        = bool
  description = "AKS alerts enabled?"
}

variable "k8s_kube_config_path_prefix" {
  type    = string
  default = "~/.kube"
}

variable "aks_kubernetes_version" {
  type        = string
  description = "Kubernetes version specified when creating the AKS managed cluster."
  default     = "1.22.6"
}

variable "aks_sku_tier" {
  type        = string
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA)."
}

variable "aks_system_node_pool" {
  type = object({
    name                         = string,
    vm_size                      = string,
    os_disk_type                 = string,
    os_disk_size_gb              = string,
    node_count_min               = number,
    node_count_max               = number,
    only_critical_addons_enabled = bool,
    node_labels                  = map(any),
    node_tags                    = map(any)
  })
  description = "AKS node pool system configuration"
}

variable "aks_nodepool_blue" {
  type = object({
    vm_sku_name       = string
    autoscale_enabled = optional(bool, true)
    node_count_min    = number
    node_count_max    = number
  })
  description = "Paramters for blue node pool"
}

variable "aks_nodepool_green" {
  type = object({
    vm_sku_name       = string
    autoscale_enabled = optional(bool, true)
    node_count_min    = number
    node_count_max    = number
  })
  description = "Paramters for blue node pool"
}


variable "aks_cidr_subnet" {
  type        = list(string)
  description = "Aks network address space."
}

variable "aks_cidr_subnet_user" {
  type        = list(string)
  description = "Aks network address space for user pool."
}

variable "subnet_private_endpoint_network_policies_enabled" {
  type        = string
  default     = "Disabled"
  description = "(Optional) Enable or Disable network policies for the private endpoint on the subnet. Possible values are Disabled, Enabled, NetworkSecurityGroupEnabled and RouteTableEnabled. Defaults to Disabled."
}

variable "aks_num_outbound_ips" {
  type        = number
  default     = 1
  description = "How many outbound ips allocate for AKS cluster"
}

variable "ingress_load_balancer_ip" {
  type = string
}

variable "ingress_min_replica_count" {
  type = string
}

variable "ingress_max_replica_count" {
  type = string
}

variable "nginx_helm" {
  type = object({
    version = string,
    controller = object({
      image = object({
        registry     = string,
        image        = string,
        tag          = string,
        digest       = string,
        digestchroot = string,
      }),
      resources = object({
        requests = object({
          memory : string
        })
      }),
      config = object({
        proxy-body-size : string
      })
    })
  })
  description = "nginx ingress helm chart configuration"
}

variable "reloader_helm" {
  type = object({
    chart_version = string,
    image_name    = string,
    image_tag     = string
  })
  description = "reloader helm chart configuration"
}

variable "skip_metric_validation" {
  type        = bool
  description = "(Optional) Skip the metric validation to allow creating an alert rule on a custom metric that isn't yet emitted? Defaults to false."
  default     = false
}

# Keda
variable "keda_helm_chart_version" {
  type        = string
  description = "keda helm chart version"
}

### ARGO
variable "argocd_helm_release_version" {
  type        = string
  description = "ArgoCD helm chart release version"
}

variable "argocd_force_reinstall_version" {
  type = string
  description = "version to force reinstall ArgoCD"
}

variable "argocd_pdb_enabled" {
    type        = bool
    description = "Enable Pod Disruption Budget for ArgoCD"
}

variable "argocd_min_replicas" {
    type        = number
    description = "Minimum number of replicas for ArgoCD"
}

variable "argocd_max_replicas" {
    type        = number
    description = "Maximum number of replicas for ArgoCD"
}
