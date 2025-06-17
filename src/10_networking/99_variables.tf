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

variable "domain" {
  type = string
  validation {
    condition = (
      length(var.domain) <= 12
    )
    error_message = "Max length is 12 chars."
  }
}

variable "default_zones" {
  type        = list(number)
  default     = []
  description = "(Optional) List of availability zones"
}

#
# NAT Configs
#
variable "nat_idle_timeout_in_minutes" {
  type        = number
  description = "The idle timeout which should be used in minutes."
}

variable "nat_sku" {
  type        = string
  default     = "Standard"
  description = "(Optional) The SKU which should be used. At this time the only supported value is Standard. Defaults to Standard."
}

#
# HUB Vnet & Subnets CIDR
#

variable "cidr_core_hub_vnet" {
  type        = list(string)
  description = "Address prefixes vnet core"
}

variable "cidr_subnet_azdoa" {
  type        = list(string)
  description = "Azure DevOps agent network address space."
}


variable "cidr_subnet_vpn" {
  type        = list(string)
  description = "VPN network address space."
}

# variable "cidr_subnet_packer_dns_forwarder" {
#   type        = list(string)
#   description = "VPN network address space."
# }

variable "cidr_subnet_dnsforwarder_vmss" {
  type        = list(string)
  description = "DNS Forwarder network address space for VMSS."
}

variable "cidr_subnet_dnsforwarder_lb" {
  type        = list(string)
  description = "DNS Forwarder network address space for LB."
}

# variable "cidr_subnet_packer_azdo" {
#   type        = list(string)
#   description = "packer azdo network address space."
# }

#
# SPOKE Vnet & Subnets CIDR
#

variable "cidr_spoke_platform_core_vnet" {
  type        = list(string)
  description = "Address prefixes vnet platform core"
}

variable "cidr_spoke_data_vnet" {
  type        = list(string)
  description = "Address prefixes vnet data"
}

variable "cidr_subnet_data_monitor_workspace" {
  type        = list(string)
  description = "Address prefixes vnet data monitor workspace"
}

variable "cidr_spoke_compute_vnet" {
  type        = list(string)
  description = "Address prefixes vnet compute"
}

variable "cidr_spoke_security_vnet" {
  type        = list(string)
  description = "Address prefixes vnet security"
}

#
# VPN
#
variable "vpn_sku" {
  type        = string
  description = "VPN Gateway SKU"
}

variable "vpn_pip_sku" {
  type        = string
  description = "VPN GW PIP SKU"
}

### DNS Forwarder

variable "dns_forwarder_vmss_image_version" {
  type        = string
  description = "vpn dns forwarder image version"
}
