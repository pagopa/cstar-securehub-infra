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

# 🗄️ Compliance / Audit — archiviazione log su Blob Storage
variable "audit_export_enabled" {
  type        = bool
  description = "If true, exports the tracing tables to a dedicated Cool Blob Storage account for long-term audit retention. Enable in prod; can be disabled in dev/uat to avoid any cost."
  default     = false
}

variable "audit_logs_retention_days" {
  type        = number
  description = "Number of days the exported audit logs are kept in Blob Storage before being permanently deleted by the lifecycle policy (compliance window, e.g. 180 days = 6 months)."
  default     = 180
  validation {
    condition     = var.audit_logs_retention_days >= 1 && var.audit_logs_retention_days <= 3650
    error_message = "Audit retention must be between 1 and 3650 days."
  }
}

variable "audit_storage_account_replication_type" {
  type        = string
  description = "Replication type for the audit Storage Account. Use LRS for the cheapest option (dev/uat); ZRS/GRS for production durability/compliance."
  default     = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "ZRS", "RAGRS", "GZRS"], var.audit_storage_account_replication_type)
    error_message = "Must be one of: LRS, GRS, ZRS, RAGRS, GZRS."
  }
}

variable "aks_nodepool" {
  type = object({
    vm_sku_name       = string
    autoscale_enabled = optional(bool, true)
    node_count_min    = number
    node_count_max    = number
  })
  description = "Parameters for node pool"
}

variable "cosmos_mongodb_params_weu" {
  type = object({
    capabilities   = list(string)
    offer_type     = string
    server_version = string
    kind           = string
    consistency_policy = object({
      consistency_level       = string
      max_interval_in_seconds = number
      max_staleness_prefix    = number
    })
    enable_free_tier                 = bool
    main_geo_location_zone_redundant = bool
    additional_geo_locations = list(object({
      location          = string
      failover_priority = number
      zone_redundant    = bool
    }))
    is_virtual_network_filter_enabled = bool
    backup_continuous_enabled         = bool
    ip_range_filter                   = optional(list(string), null)
  })
  description = "Parameters for cosmosdb account WEU"
  default     = null
}

variable "cosmos_mongodb_common_configuration" {
  type = object({
    max_throughput    = number
    autoscale_enabled = bool
  })
  description = "Parameters for Cosmos DB account in West Europe"
}


variable "additional_geo_locations" {
  type = list(object({
    location          = string
    failover_priority = number
    zone_redundant    = bool
  }))
  default     = []
  description = "Specifies a list of additional geo_location resources, used to define where data should be replicated."
}

variable "dns_zone_public_name" {
  type        = string
  description = "Public DNS zone name, e.g. 'dev.cstar.pagopa.it'"
}

variable "robots_indexed_paths" {
  type        = list(string)
  default     = []
  description = "List of paths that should be indexed by robots. All others will get noindex header."
}

variable "backoffice_cdn_storage_replication_type" {
  type        = string
  default     = "LRS"
  description = "Storage account replication type for the backoffice CDN. Use LRS for dev/uat, ZRS or GRS for prod."
  validation {
    condition     = contains(["LRS", "GRS", "ZRS", "RAGRS", "GZRS"], var.backoffice_cdn_storage_replication_type)
    error_message = "Must be one of: LRS, GRS, ZRS, RAGRS, GZRS."
  }
}
