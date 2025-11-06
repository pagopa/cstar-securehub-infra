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

#
# DNS
#
variable "dns_zone_internal_prefix" {
  type        = string
  default     = ""
  description = "The dns subdomain."
}

variable "external_domain" {
  type        = string
  description = "Domain for delegation"
}

variable "mcshared_dns_zone_prefix" {
  type        = string
  default     = null
  description = "The dns subdomain for mcshared"
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
    zone                                   = number
    idh_resource_tier                      = string
    geo_replication_enabled                = bool
    pgres_flex_pgbouncer_enabled           = bool
    pgres_flex_diagnostic_settings_enabled = bool
    auto_grow_enabled                      = bool
  })
}

variable "keycloak_configuration" {
  type = object({
    image_repository                            = string
    image_tag                                   = string
    image_registry                              = string
    chart_version                               = string
    replica_count_min                           = number
    replica_count_max                           = number
    cpu_request                                 = string
    cpu_limit                                   = string
    memory_request                              = string
    memory_limit                                = string
    http_client_connection_ttl_millis           = number
    http_client_connection_max_idle_time_millis = number
    image_registry_config_cli                   = string
    image_repository_config_cli                 = string
    image_tag_config_cli                        = string
  })
}

variable "aks_user_node_pool_keycloak" {
  type = object({
    idh_resource_tier = string
    node_count_min    = number
    node_count_max    = number
    os_disk_size_gb   = optional(number, null)
    os_disk_type      = optional(string, null)
  })
}
