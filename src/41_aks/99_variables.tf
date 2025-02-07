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

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

variable "domain" {
  type = string
  validation {
    condition = (
      length(var.domain) <= 12
    )
    error_message = "Max length is 12 chars."
  }
}

### AKS

variable "k8s_kube_config_path_prefix" {
  type    = string
  default = "~/.kube"
}

variable "aks_sku_tier" {
  type        = string
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA)."
}

variable "aks_cidr_system_subnet" {
  type        = list(string)
  description = "Aks system network address space."
}

variable "aks_cidr_user_subnet" {
  type        = list(string)
  description = "Aks user network address space."
}

variable "aks_kubernetes_version" {
  type        = string
  description = "Kubernetes version specified when creating the AKS managed cluster."
}

variable "aks_system_node_pool" {
  type = object({
    name                         = string
    vm_size                      = string
    os_disk_type                 = string
    os_disk_size_gb              = string
    node_count_min               = number
    node_count_max               = number
    only_critical_addons_enabled = bool
    node_labels                  = map(any)
    node_tags                    = map(any)
  })
  description = "AKS node pool system configuration"
}

variable "aks_user_node_pool_standalone" {
  type = object({
    enabled                    = optional(bool, true),
    name                       = string,
    vm_size                    = string,
    os_disk_type               = string,
    os_disk_size_gb            = string,
    node_count_min             = number,
    node_count_max             = number,
    node_labels                = map(any),
    node_taints                = list(string),
    node_tags                  = map(any),
    ultra_ssd_enabled          = optional(bool, false),
    enable_host_encryption     = optional(bool, true),
    max_pods                   = optional(number, 250),
    upgrade_settings_max_surge = optional(string, "30%"),
    zones                      = optional(list(any), [1, 2, 3]),
  })
  description = "AKS node pool user configuration"
}


variable "aks_num_outbound_ips" {
  type        = number
  default     = 1
  description = "How many outbound ips allocate for AKS cluster"
}

variable "aks_ip_availability_zones" {
  type        = list(string)
  default     = ["1", "2", "3"]
  description = "List of zones"
}

variable "aks_private_cluster_is_enabled" {
  type        = bool
  description = "Allow to configure the AKS, to be setup as a private cluster. To reach it, you need to use an internal VM or VPN"
  default     = true
}

variable "aks_alerts_enabled" {
  type        = bool
  default     = false
  description = "AKS alerts enabled?"
}

# Nginx
variable "nginx_ingress_helm_version" {
  type        = string
  description = "Nginx ingress helm version https://github.com/kubernetes/ingress-nginx"
}

# Keda
variable "keda_helm_chart_version" {
  type        = string
  description = "keda helm chart version"
}

# DNS
variable "dns_zone_internal_prefix" {
  type        = string
  default     = null
  description = "The dns subdomain."
}

variable "external_domain" {
  type        = string
  description = "Domain for delegation"
}

### ARGO
variable "argocd_helm_release_version" {
  type        = string
  description = "ArgoCD helm chart release version"
}
