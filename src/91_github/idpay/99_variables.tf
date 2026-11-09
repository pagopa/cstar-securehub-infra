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

variable "functional_testing_ui_base_url_welfare_enti" {
  type        = string
  description = "Base URL for welfare enti UI tests."
  default     = null
  validation {
    condition     = var.env == "prod" || var.functional_testing_ui_base_url_welfare_enti != null
    error_message = "functional_testing_ui_base_url_welfare_enti must be set in dev and uat."
  }
}

variable "functional_testing_ui_base_url_welfare_esercenti" {
  type        = string
  description = "Base URL for welfare esercenti UI tests."
  default     = null
  validation {
    condition     = var.env == "prod" || var.functional_testing_ui_base_url_welfare_esercenti != null
    error_message = "functional_testing_ui_base_url_welfare_esercenti must be set in dev and uat."
  }
}

variable "functional_testing_ui_base_url_rdb" {
  type        = string
  description = "Base URL for RDB UI tests."
  default     = null
  validation {
    condition     = var.env == "prod" || var.functional_testing_ui_base_url_rdb != null
    error_message = "functional_testing_ui_base_url_rdb must be set in dev and uat."
  }
}

variable "functional_testing_ui_base_url_pari_utente" {
  type        = string
  description = "Base URL for PARI utente UI tests."
  default     = null
  validation {
    condition     = var.env == "prod" || var.functional_testing_ui_base_url_pari_utente != null
    error_message = "functional_testing_ui_base_url_pari_utente must be set in dev and uat."
  }
}

variable "functional_testing_ui_login_path_welfare_enti" {
  type        = string
  description = "Optional login path override for welfare enti."
  default     = "/accesso"
}

variable "functional_testing_ui_login_path_welfare_esercenti" {
  type        = string
  description = "Optional login path override for welfare esercenti."
  default     = "/accesso"
}

variable "functional_testing_ui_login_path_rdb" {
  type        = string
  description = "Optional login path override for RDB."
  default     = ""
}

variable "functional_testing_ui_login_path_pari_utente" {
  type        = string
  description = "Optional login path override for PARI utente."
  default     = ""
}

variable "functional_testing_ui_username_secret_name_welfare_enti" {
  type        = string
  description = "Key Vault secret name for welfare enti username."
  default     = null
  validation {
    condition     = var.env == "prod" || var.functional_testing_ui_username_secret_name_welfare_enti != null
    error_message = "functional_testing_ui_username_secret_name_welfare_enti must be set in dev and uat."
  }
}

variable "functional_testing_ui_password_secret_name_welfare_enti" {
  type        = string
  description = "Key Vault secret name for welfare enti password."
  default     = null
  validation {
    condition     = var.env == "prod" || var.functional_testing_ui_password_secret_name_welfare_enti != null
    error_message = "functional_testing_ui_password_secret_name_welfare_enti must be set in dev and uat."
  }
}

variable "functional_testing_ui_username_secret_name_welfare_esercenti" {
  type        = string
  description = "Key Vault secret name for welfare esercenti username."
  default     = null
  validation {
    condition     = var.env == "prod" || var.functional_testing_ui_username_secret_name_welfare_esercenti != null
    error_message = "functional_testing_ui_username_secret_name_welfare_esercenti must be set in dev and uat."
  }
}

variable "functional_testing_ui_password_secret_name_welfare_esercenti" {
  type        = string
  description = "Key Vault secret name for welfare esercenti password."
  default     = null
  validation {
    condition     = var.env == "prod" || var.functional_testing_ui_password_secret_name_welfare_esercenti != null
    error_message = "functional_testing_ui_password_secret_name_welfare_esercenti must be set in dev and uat."
  }
}

variable "functional_testing_ui_username_secret_name_rdb" {
  type        = string
  description = "Key Vault secret name for RDB username."
  default     = null
  validation {
    condition     = var.env == "prod" || var.functional_testing_ui_username_secret_name_rdb != null
    error_message = "functional_testing_ui_username_secret_name_rdb must be set in dev and uat."
  }
}

variable "functional_testing_ui_password_secret_name_rdb" {
  type        = string
  description = "Key Vault secret name for RDB password."
  default     = null
  validation {
    condition     = var.env == "prod" || var.functional_testing_ui_password_secret_name_rdb != null
    error_message = "functional_testing_ui_password_secret_name_rdb must be set in dev and uat."
  }
}

variable "functional_testing_ui_username_secret_name_pari_utente" {
  type        = string
  description = "Key Vault secret name for PARI utente username."
  default     = null
  validation {
    condition     = var.env == "prod" || var.functional_testing_ui_username_secret_name_pari_utente != null
    error_message = "functional_testing_ui_username_secret_name_pari_utente must be set in dev and uat."
  }
}

variable "functional_testing_ui_password_secret_name_pari_utente" {
  type        = string
  description = "Key Vault secret name for PARI utente password."
  default     = null
  validation {
    condition     = var.env == "prod" || var.functional_testing_ui_password_secret_name_pari_utente != null
    error_message = "functional_testing_ui_password_secret_name_pari_utente must be set in dev and uat."
  }
}
