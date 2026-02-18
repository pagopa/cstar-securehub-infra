variable "prefix" {
  type    = string
  default = "cstar"
  validation {
    condition = (
      length(var.prefix) <= 6
    )
    error_message = "Max length is 6 chars."
  }
}

variable "env" {
  type = string
  validation {
    condition = (
      length(var.env) <= 4
    )
    error_message = "Max length is 4 chars."
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

variable "location_short" {
  type        = string
  description = "Location short like eg: weu, weu.."
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

# Definizione della variabile per i nomi dei gruppi Entra ID
variable "argocd_entra_groups_allowed_extra" {
  type        = list(string)
  description = "Additional Entra ID groups allowed to access ArgoCD."
  default     = []
}
