variable "env" {
  type        = string
  description = "Environment"

  validation {
    condition     = contains(["dev", "uat", "prod"], var.env)
    error_message = "Environment must be dev, uat, or prod."
  }
}

variable "mdc_kv_name" {
  type        = string
  description = "Name of the Key Vault where the mdc secrets are stored."
}

variable "mdc_kv_rg" {
  type        = string
  description = "Name of the resource group where the mdc Key Vault is located."
}

variable "argo_cd_server" {
  type        = string
  description = "Server of the Argo CD (without https)."
  default     = null
}
