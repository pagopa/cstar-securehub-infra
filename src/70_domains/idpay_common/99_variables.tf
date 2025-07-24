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
  description = "One of westeurope, northeurope"
}

variable "location_short" {
  type = string
  validation {
    condition = (
      length(var.location_short) == 3
    )
    error_message = "Length must be 3 chars."
  }
  description = "One of wue, neu"
}

variable "location_weu" {
  type        = string
  description = "One of westeurope, northeurope"
}

variable "location_short_weu" {
  type = string
  validation {
    condition = (
      length(var.location_short_weu) == 3
    )
    error_message = "Length must be 3 chars."
  }
  description = "One of wue, neu"
}

#
# 🛜 Network
#

variable "dns_zone_internal_prefix" {
  type        = string
  description = "The dns subdomain."
}

variable "cosmos_mongo_db_idpay_params" {
  type = object({
    throughput     = number
    max_throughput = number
  })
}

# DNS
variable "external_domain" {
  type        = string
  description = "Domain for delegation"
}

variable "dns_zone_prefix" {
  type        = string
  description = "The dns subdomain."
}

#CDN
variable "robots_indexed_paths" {
  type        = list(string)
  description = "List of cdn paths to allow robots index"
  # default     = []
}

# Single Page Applications
variable "single_page_applications_roots_dirs" {
  type        = list(string)
  description = "spa root dirs"
}

# Single Page Applications Asset register
variable "single_page_applications_asset_register_roots_dirs" {
  type        = list(string)
  description = "spa root dirs"
}

# Single Page Applications Merchants Operator
variable "single_page_applications_portal_merchants_operator_roots_dirs" {
  type        = list(string)
  description = "spa root dirs"
}


## Event hub
variable "ehns_sku_name" {
  type        = string
  description = "Defines which tier to use."
  # default     = "Basic"
}

variable "ehns_capacity" {
  type        = number
  description = "Specifies the Capacity / Throughput Units for a Standard SKU namespace."
  # default     = null
}

variable "ehns_maximum_throughput_units" {
  type        = number
  description = "Specifies the maximum number of throughput units when Auto Inflate is Enabled"
  # default     = null
}

variable "ehns_auto_inflate_enabled" {
  type        = bool
  description = "Is Auto Inflate enabled for the EventHub Namespace?"
  # default     = false
}

variable "ehns_alerts_enabled" {
  type = bool
  # default     = true
  description = "Event hub alerts enabled?"
}
variable "ehns_metric_alerts" {
  default = {}

  description = <<EOD
Map of name = criteria objects
EOD

  type = map(object({
    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]
    aggregation = string
    metric_name = string
    description = string
    # criteria.0.operator to be one of [Equals NotEquals GreaterThan GreaterThanOrEqual LessThan LessThanOrEqual]
    operator  = string
    threshold = number
    # Possible values are PT1M, PT5M, PT15M, PT30M and PT1H
    frequency = string
    # Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D.
    window_size = string

    dimension = list(object(
      {
        name     = string
        operator = string
        values   = list(string)
      }
    ))
  }))
}

variable "service_bus_namespace" {
  type = object({
    sku                          = string
    capacity                     = optional(number, 0)
    premium_messaging_partitions = optional(number, 0)
  })
}

### External resources
variable "enable" {
  type = object({
    idpay = object({
      eventhub_idpay_00 = bool
      eventhub_idpay_01 = bool
      eventhub_rdb      = bool
    })
  })
  description = "Feature flags"
  default = {
    idpay = {
      eventhub_idpay_00 = false
      eventhub_idpay_01 = false
      eventhub_rdb      = false
    }
  }
}

variable "idpay_cdn_sa_advanced_threat_protection_enabled" {
  type = bool
  # default = false
}

variable "idpay_cdn_storage_account_replication_type" {
  type        = string
  description = "Which replication must use the blob storage under cdn"
}

variable "selfcare_welfare_cdn_storage_account_replication_type" {
  type        = string
  description = "Which replication must use the blob storage under cdn"
}

#
# AKS
#
variable "k8s_kube_config_path_prefix" {
  type    = string
  default = "~/.kube"
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

variable "mcshared_dns_zone_prefix" {
  type        = string
  default     = null
  description = "The dns subdomain for mcshared"
}
