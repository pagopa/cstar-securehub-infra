variable "prefix" {
  type = string
  validation {
    condition = (
      length(var.prefix) <= 6
    )
    error_message = "Max length is 6 chars."
  }
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

variable "env" {
  type        = string
  description = "Environment"
}

variable "location_short" {
  type        = string
  description = "Location short like eg: neu, weu.."
}

variable "location" {
  type        = string
  description = "Location extended like eg: northeurope, westeurope."
  default     = "italynorth"
}

variable "domain" {
  type        = string
  description = "Domain used for tags."
  default     = "idpay"
}

variable "datavault_service_url" {
  type        = string
  description = "URL of the datavault service."
  default     = "https://idpay.itn.internal.uat.cstar.pagopa.it/mcshareddatavault"
}

variable "aca_env_name" {
  type        = string
  description = "Name of the ACA environment used for self-hosted runners."
}

variable "aca_env_rg" {
  type        = string
  description = "Name of the resource group where the ACA environment used for self-hosted runners is deployed."
}
