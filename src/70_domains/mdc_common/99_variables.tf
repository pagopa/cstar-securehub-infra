# general

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
  type = string
}

variable "env_short" {
  type = string
  validation {
    condition = (
      length(var.env_short) == 1
    )
    error_message = "Length must be 1 chars."
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

variable "location" {
  type        = string
  description = "One of italynorth, westeurope"
}

variable "location_short" {
  type = string
  validation {
    condition = (
      length(var.location_short) == 3
    )
    error_message = "Length must be 3 chars."
  }
  description = "One of itn, weu"
}

variable "k8s_kube_config_path_prefix" {
  type        = string
  default     = "~/.kube"
  description = "DO NOT REMOVE. Used in code review e deploy pipelines. https://github.com/pagopa/azure-pipeline-templates/tree/master/templates/terraform-plan-apply & https://github.com/pagopa/azure-pipeline-templates/tree/master/templates/terraform-plan"
}

variable "ingress_private_load_balancer_ip" {
  type = string
}

# DNS

variable "external_domain" {
  type        = string
  default     = null
  description = "Domain for delegation"
}

variable "dns_zone_internal_prefix" {
  type        = string
  default     = null
  description = "The DNS subdomain."
}

#Redis
variable "redis_idh_tier" {
  type = string
}

## Monitor
variable "law_sku" {
  type        = string
  description = "Sku of the Log Analytics Workspace"
  default     = "PerGB2018"
}

variable "law_retention_in_days" {
  type        = number
  description = "The workspace data retention in days"
  default     = 30
}

variable "law_daily_quota_gb" {
  type        = number
  description = "The workspace daily quota for ingestion in GB."
  default     = -1
}

variable "aks_nodepool" {
  type = object({
    vm_sku_name       = string
    autoscale_enabled = optional(bool, true)
    node_count_min    = number
    node_count_max    = number
  })
  description = "Paramters for node pool"
}
