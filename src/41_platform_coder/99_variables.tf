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

variable "location_display_name" {
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

#
# Kubernetes
#
variable "k8s_kube_config_path_prefix" {
  type    = string
  default = "~/.kube"
}

#
# Postgres Flexible
#
variable "keycloak_pgflex_params" {
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

variable "keycloak_configuration" {
  type = object({
    replica_count_min = number
    replica_count_max = number
  })
}
