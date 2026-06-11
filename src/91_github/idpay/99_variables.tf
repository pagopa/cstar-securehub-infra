variable "env" {
  type        = string
  description = "Environment"

  validation {
    condition     = contains(["dev", "uat", "prod"], var.env)
    error_message = "Environment must be dev, uat, or prod."
  }
}

variable "cicd_kv_name" {
  type        = string
  description = "Name of the Key Vault where the CI/CD secrets are stored."
}

variable "cicd_kv_rg" {
  type        = string
  description = "Name of the resource group where the CI/CD Key Vault is located."
}

variable "idpay_kv_name" {
  type        = string
  description = "Name of the Key Vault where the IDPay secrets are stored."
}

variable "idpay_kv_rg" {
  type        = string
  description = "Name of the resource group where the IDPay Key Vault is located."
}

variable "datavault_service_url" {
  type        = string
  description = "URL of the datavault service."
  default     = null
}

variable "argo_cd_server" {
  type        = string
  description = "Server of the Argo CD (without https)."
  default     = null
}
