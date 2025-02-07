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
# Vnet & Subnets CIDR
#

variable "cidr_core_vnet" {
  type        = list(string)
  description = "Address prefixes vnet core"
}

variable "cidr_subnet_apim" {
  type        = list(string)
  description = "Address prefixes subnet api management."
  default     = null
}

variable "cidr_subnet_appgateway" {
  type        = list(string)
  description = "Address prefixes subnet appgateway."
  default     = null
}

variable "cidr_vpn_subnet" {
  type        = list(string)
  description = "Address prefixes subnet vpn"
  default     = null
}

variable "cidr_subnet_azdoa" {
  type        = list(string)
  description = "Azure DevOps agent network address space."
}

variable "cidr_subnet_prv_endpoint" {
  type        = list(string)
  description = "Address prefixes subnet private endpoint."
}

#
# DNS Forwarder
#
variable "dns_forwarder_vm_image_version" {
  type        = string
  description = "Version of dns forwarder image created in 03_packer"
}

#
# VPN
#

variable "vpn_sku" {
  type        = string
  default     = "VpnGw1"
  description = "VPN Gateway SKU"
}

variable "vpn_pip_sku" {
  type        = string
  default     = "Basic"
  description = "VPN GW PIP SKU"
}

#
# DNS
#

variable "dns_zone_prefix" {
  type        = string
  default     = null
  description = "The dns subdomain."
}

variable "external_domain" {
  type        = string
  default     = null
  description = "Domain for delegation"
}

variable "dns_zone_internal_prefix" {
  type        = string
  default     = null
  description = "The dns subdomain."
}

variable "dns_default_ttl_sec" {
  type        = number
  description = "value"
  default     = 3600
}

#
# General Common
#

variable "zones" {
  type        = list(number)
  default     = []
  description = "(Optional) List of availability zones on which the API management and appgateway will be deployed"
}

#
# Azure DevOps Agent
#

variable "enable_azdoa" {
  type        = bool
  default     = true
  description = "Enable Azure DevOps agent."
}
