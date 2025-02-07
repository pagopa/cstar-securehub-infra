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

variable "k8s_kube_config_path_prefix" {
  type    = string
  default = "~/.kube"
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

### DNS
variable "dns_zone_internal_prefix" {
  type        = string
  default     = null
  description = "The dns subdomain."
}

variable "external_domain" {
  type        = string
  description = "Domain for delegation"
}

#
# Network
#
variable "cidr_postgres_subnet" {
  type        = list(string)
  description = "Address prefixes subnet postgres"
  default     = null
}

#
# CosmosDB
#
variable "cosmos_cassandra_account_params" {
  type = object({
    enabled      = bool
    capabilities = list(string)
    offer_type   = string
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

#
# Temporal.io
#
variable "temporal_io_docker_admin_tools_version" {
  type        = string
  description = "Temporal admin tools image name & version. You can find it on https://hub.docker.com/r/temporalio/admin-tools/tags. E.g. temporalio/admin-tools:1.25.2-tctl-1.18.1-cli-1.1.1"
}

variable "temporal_io_postgres_schema_version" {
  type        = string
  description = "Postgres schema version. The schema version can be found here https://github.com/temporalio/temporal/tree/main/schema/postgresql/v12/temporal/versioned"
}

# Postgres Flexible
variable "temporal_pgflex_params" {
  type = object({
    enabled                                = bool
    sku_name                               = string
    db_version                             = string
    storage_mb                             = string
    zone                                   = number
    standby_zone                           = optional(number, 1)
    backup_retention_days                  = number
    geo_redundant_backup_enabled           = bool
    create_mode                            = string
    pgres_flex_private_endpoint_enabled    = bool
    pgres_flex_ha_enabled                  = bool
    pgres_flex_pgbouncer_enabled           = bool
    pgres_flex_diagnostic_settings_enabled = bool
    max_connections                        = number
    pgbouncer_min_pool_size                = number
    pgbouncer_default_pool_size            = number
  })
}

variable "aks_cidr_user_subnet" {
  type        = list(string)
  description = "Aks user network address space."
}


variable "artemis_config" {
  type = object({
    chart_version              = string
    image_repository           = string
    image_tag                  = string
    replica_count              = number
    high_availability          = bool
    persistence                = bool
    storage_class              = string
    access_mode                = string
    storage_size               = string
    management_console_enabled = bool
  })
  description = "Aks user network address space."
}
