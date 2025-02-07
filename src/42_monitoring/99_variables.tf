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

variable "location_westeurope" {
  type = string
}

variable "location_short_westeurope" {
  type        = string
  description = "Location short like eg: weu.."
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
# Grafana
#
variable "grafana_zone_redundancy_enabled" {
  type        = bool
  description = "(Required) Whether to enable the zone redundancy setting of the Grafana instance. Changing this forces a new Dashboard Grafana to be created."
}

variable "grafana_major_version" {
  type        = number
  description = "(Required) Which major version of Grafana to deploy. Possible values are 9, 10. Changing this forces a new resource to be created."
}
