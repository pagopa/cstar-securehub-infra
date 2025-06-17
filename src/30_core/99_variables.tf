## General
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

variable "pagopa_location_short" {
  type        = string
  description = "Pagopa's location short like eg: weu.."
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

#
# Azure DevOps Agent
#

variable "enable_azdoa" {
  type        = bool
  description = "Enable Azure DevOps agent."
}

variable "devops_agent_zones" {
  type        = list(number)
  default     = null
  description = "(Optional) List of zones in which the scale set for azdo agent will be deployed"
}


variable "devops_agent_balance_zones" {
  type        = bool
  default     = false
  description = "(Optional) True if the devops agent instances must be evenly balanced between the configured zones"
}

variable "azdo_agent_image_version" {
  type        = string
  description = "Version as suffix to define the image related to azdo agent"
}
