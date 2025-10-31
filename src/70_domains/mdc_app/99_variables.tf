# general

variable "prefix" {
  type = string
  validation {
    condition     = length(var.prefix) <= 6
    error_message = "Max length is 6 chars."
  }
}

variable "env" {
  type = string
}

variable "env_short" {
  type = string
  validation {
    condition     = length(var.env_short) == 1
    error_message = "Length must be 1 chars."
  }
}

variable "domain" {
  type = string
  validation {
    condition     = length(var.domain) <= 12
    error_message = "Max length is 12 chars."
  }
}

variable "location" {
  type        = string
  description = "One of italynorth, westeurope"
}

variable "location_string" {
  type        = string
  description = "One of Italy North, West Europe"
}

variable "location_short" {
  type = string
  validation {
    condition     = length(var.location_short) == 3
    error_message = "Length must be 3 chars."
  }
  description = "One of itn, weu"
}

variable "instance" {
  type        = string
  description = "One of beta, prod01, prod02"
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

### Aks

variable "aks_name" {
  type        = string
  description = "AKS cluster name"
}

variable "aks_resource_group_name" {
  type        = string
  description = "AKS cluster resource name"
}

variable "k8s_kube_config_path_prefix" {
  type    = string
  default = "~/.kube"
}

variable "ingress_load_balancer_ip" {
  type = string
}

variable "ingress_load_balancer_hostname" {
  type = string
}

# DNS
variable "external_domain" {
  type        = string
  description = "Domain for delegation"
}

variable "dns_zone_prefix" {
  type        = string
  default     = "cstar"
  description = "The dns subdomain."
}

variable "dns_zone_internal_prefix" {
  type        = string
  description = "The dns subdomain."
}

variable "aks_cluster_domain_name" {
  type        = string
  description = "Name of the aks cluster domain. eg: dev01"
}

variable "enable" {
  type        = object({})
  description = "Feature flags"
  default     = {}
}

variable "event_hub_port" {
  type = number
}
