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
    storage_tier                           = optional(string, null)
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
    image_digest_config_cli                     = optional(string, "")
  })
}

variable "listmonk_configuration" {
  type = object({
    chart_version            = string
    image_repository         = string
    image_tag                = string
    replica_count            = number
    postgres_ssl_mode        = string
    bootstrap_postgres_image = optional(string, "postgres:17-alpine")
  })

  validation {
    condition = contains([
      "require",
      "verify-ca",
      "verify-full"
    ], var.listmonk_configuration.postgres_ssl_mode)
    error_message = "Listmonk must use TLS: postgres_ssl_mode must be require, verify-ca, or verify-full."
  }

  validation {
    condition     = var.listmonk_configuration.replica_count == 1
    error_message = "Listmonk must run a single active replica to avoid concurrent campaign processing."
  }
}

variable "listmonk_sso" {
  description = "Native Microsoft Entra OIDC. Enable after registering the app and storing its client secret in the core Key Vault."
  type = object({
    enabled              = bool
    client_id            = string
    client_secret_name   = string
    auto_create_users    = optional(bool, false)
    default_user_role_id = optional(number)
  })

  validation {
    condition     = !var.listmonk_sso.enabled || (can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.listmonk_sso.client_id)) && trimspace(var.listmonk_sso.client_secret_name) != "")
    error_message = "Enabling Listmonk SSO requires an Entra application client ID and a core Key Vault client-secret name."
  }

  validation {
    condition     = !var.listmonk_sso.auto_create_users || try(var.listmonk_sso.default_user_role_id >= 1 && floor(var.listmonk_sso.default_user_role_id) == var.listmonk_sso.default_user_role_id, false)
    error_message = "Auto-creating OIDC users requires an explicit, existing Listmonk user role ID."
  }
}

variable "aks_user_node_pool_keycloak" {
  type = object({
    enabled           = optional(bool, true)
    idh_resource_tier = string
    node_count_min    = number
    node_count_max    = number
    os_disk_size_gb   = optional(number, null)
    os_disk_type      = optional(string, null)
  })
}

variable "aks_user_foobar_node_pool_keycloak" {
  type = object({
    enabled           = optional(bool, true)
    idh_resource_tier = string
    node_count_min    = number
    node_count_max    = number
    os_disk_size_gb   = optional(number, null)
    os_disk_type      = optional(string, null)
  })
}
