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

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

#
# 🛜 Network
#
variable "cidr_idpay_data_cosmos" {
  type        = list(string)
  description = "Cosmos subnet network address space."
  # default     = []
}

variable "cidr_idpay_data_eventhub" {
  type        = list(string)
  description = "Eventhub subnet network address space."
  # default     = []
}

variable "cidr_idpay_data_redis" {
  type        = list(string)
  description = "Redis subnet network address space."
  # default     = []
}

variable "cidr_idpay_data_servicebus" {
  type        = list(string)
  description = "Servicebus subnet network address space."
  # default     = []
}

variable "dns_zone_internal_prefix" {
  type        = string
  description = "The dns subdomain."
}

#
#
#
variable "rtd_keyvault" {
  type = object({
    name           = string
    resource_group = string
  })
}

variable "cosmos_mongo_account_params" {
  type = object({
    enabled        = bool
    capabilities   = list(string)
    offer_type     = string
    server_version = string
    consistency_policy = object({
      consistency_level       = string
      max_interval_in_seconds = number
      max_staleness_prefix    = number
    })
    main_geo_location_zone_redundant = bool
    enable_free_tier                 = bool
    additional_geo_locations = list(object({
      location          = string
      failover_priority = number
      zone_redundant    = bool
    }))
    private_endpoint_enabled          = bool
    public_network_access_enabled     = bool
    is_virtual_network_filter_enabled = bool
    backup_continuous_enabled         = bool
  })
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

variable "ns_dns_records_welfare" {
  type = list(object({
    name    = string
    records = list(string)
  }))
  description = "ns records to delegate the dns zone into the subscription/env."
  default     = []
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

variable "eventhubs_idpay" {
  description = "A list of event hubs to add to namespace for IDPAY application."
  type = list(object({
    name              = string
    partitions        = number
    message_retention = number
    consumers         = list(string)
    keys = list(object({
      name   = string
      listen = bool
      send   = bool
      manage = bool
    }))
  }))
  # default = []
}

variable "eventhubs_idpay_01" {
  description = "A list of event hubs to add to namespace for IDPAY application."
  type = list(object({
    name              = string
    partitions        = number
    message_retention = number
    consumers         = list(string)
    keys = list(object({
      name   = string
      listen = bool
      send   = bool
      manage = bool
    }))
  }))
  # default = []
}

variable "ehns_alerts_enabled" {
  type        = bool
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

#Redis
variable "redis_params" {
  type = object({
    capacity = number
    family   = string
    sku_name = string
  })
  description = "Redis configuration parameters"
}

variable "service_bus_namespace" {
  type = object({
    sku = string
  })
}

### External resources
variable "enable" {
  type = object({
    idpay = object({
      eventhub_idpay_00 = bool
      eventhub_idpay_01 = bool
    })
  })
  description = "Feature flags"
  default = {
    idpay = {
      eventhub_idpay_00 = false
      eventhub_idpay_01 = false
    }
  }
}

variable "aks_vnet" {
  type = object({
    name           = string
    resource_group = string
    subnet         = string
  })
}

variable "idpay_cdn_sa_advanced_threat_protection_enabled" {
  type    = bool
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
variable "aks_resource_group_name" {
  type        = string
  description = "(Required) Resource group of the Kubernetes cluster."
}

variable "aks_name" {
  type        = string
  description = "(Required) Name of the Kubernetes cluster."
}

variable "k8s_kube_config_path_prefix" {
  type    = string
  default = "~/.kube"
}

variable "storage_account_settings" {
  type = object({
    replication_type                   = string
    delete_retention_days              = number
    enable_versioning                  = bool
    advanced_threat_protection_enabled = bool
  })
}
