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

variable "domain" {
  type = string
  validation {
    condition = (
      length(var.domain) <= 12
    )
    error_message = "Max length is 12 chars."
  }
}

## CDN

variable "cdn_location" {
  type        = string
  description = "One of westeurope, northeurope"
}

variable "azuread_service_principal_azure_cdn_frontdoor_id" {
  type        = string
  description = "Azure CDN Front Door Principal ID - Microsoft.AzureFrontDoor-Cdn"
}

## Analytics Workspace
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

variable "enable_cdn" {
  type        = bool
  description = "Enable CDN for the domain"
}

variable "cosmos_collections_autoscale_max_throughput" {
  type        = number
  description = "Max throughput for autoscale"
  default     = null
}

variable "cosmos_collections_max_throughput" {
  type        = number
  description = "Max throughput for collections"
  default     = null
}

variable "k8s_kube_config_path_prefix" {
  type    = string
  default = "~/.kube"
}

variable "aks_user_nodepool" {
  type = object({
    vm_sku_name       = string
    autoscale_enabled = optional(bool, true)
    node_count_min    = number
    node_count_max    = number
  })
  description = "Paramters for node pool"
}
