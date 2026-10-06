variable "env" {
  type        = string
  description = "Environment"

  validation {
    condition     = contains(["dev", "uat", "prod"], var.env)
    error_message = "Environment must be dev, uat, or prod."
  }
}

variable "env_short" {
  type        = string
  description = "Short environment code (d, u, p)."

  validation {
    condition     = contains(["d", "u", "p"], var.env_short)
    error_message = "env_short must be d, u, or p."
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

variable "functional_testing_secret_name" {
  type        = string
  description = "Name of the secret for functional test."
  default     = null
  validation {
    condition     = var.env == "prod" || var.functional_testing_secret_name != null
    error_message = "functional_testing_secret_name must be set in dev and uat."
  }
}
