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
  type = string
}

variable "env_short" {
  type = string
  validation {
    condition = (
      length(var.env_short) == 1
    )
    error_message = "Length must be 1 chars."
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

variable "idpay_alert_enabled" {
  type    = bool
  default = false
}

variable "location" {
  type        = string
  description = "One of italynorth, northeurope"
}

variable "location_string" {
  type        = string
  description = "One of Italy North, North Europe"
}

variable "location_short" {
  type = string
  validation {
    condition = (
      length(var.location_short) == 3
    )
    error_message = "Length must be 3 chars."
  }
  description = "One of wue, neu"
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

variable "event_hub_port" {
  type    = number
  default = 9093
}

### External resources

variable "monitor_resource_group_name" {
  type        = string
  description = "Monitor resource group name"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Specifies the name of the Log Analytics Workspace."
}

variable "log_analytics_workspace_resource_group_name" {
  type        = string
  description = "The name of the resource group in which the Log Analytics workspace is located in."
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

variable "aks_vmss_name" {
  type        = string
  description = "AKS nodepool scale set name"
}

variable "k8s_kube_config_path_prefix" {
  type    = string
  default = "~/.kube"
}

variable "ingress_load_balancer_ip" {
  type = string
}

variable "ingress_domain_hostname" {
  type = string
}

# DNS
variable "external_domain" {
  type        = string
  description = "Domain for delegation"
}

variable "dns_zone_internal_prefix" {
  type        = string
  description = "The dns subdomain."
}

# #APP IO
# variable "appio_timeout_sec" {
#   type        = number
#   description = "AppIo timeout (sec)"
# }

variable "reverse_proxy_be_io" {
  type        = string
  default     = "127.0.0.1"
  description = "AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller."
}

# variable "eventhub_pim" {
#   type = object({
#     enrolled_pi_eventhub  = string,
#     revoked_pi_eventhub   = string,
#     resource_group_name   = string,
#     namespace_enrolled_pi = string
#     namespace_revoked_pi  = string
#   })
#   description = "Namespace and groupname configuration for enrolled payment instrument eventhub"
# }

variable "one_trust_privacynotice_base_url" {
  type        = string
  description = "OneTrust PrivacyNotice Base Url"
}

variable "io_manage_backend_base_url" {
  type        = string
  description = "BE IO manage backend url"
}
variable "openid_config_url_mil" {
  type        = string
  description = "Token MIL, OIDC URL"
}
variable "pdv_tokenizer_url" {
  type        = string
  default     = "127.0.0.1"
  description = "PDV uri. Endpoint for encryption of pii information."
}

variable "pdv_timeout_sec" {
  type        = number
  description = "PDV timeout (sec)"
  default     = 15
}

variable "pdv_retry_count" {
  type        = number
  description = "PDV max retry number"
  default     = 3
}

variable "pdv_retry_interval" {
  type        = number
  description = "PDV interval between each retry"
  default     = 5
}

variable "pdv_retry_max_interval" {
  type        = number
  description = "PDV max interval between each retry"
  default     = 15
}

variable "pdv_retry_delta" {
  type        = number
  description = "PDV delta"
  default     = 1
}

variable "checkiban_base_url" {
  type        = string
  default     = "127.0.0.1"
  description = "Check IBAN uri."
}

variable "selc_base_url" {
  type        = string
  description = "SelfCare api backend url"
}

variable "selc_timeout_sec" {
  type        = number
  description = "SelfCare api timeout (sec)"
  default     = 5
}

variable "pm_service_base_url" {
  type        = string
  default     = "127.0.0.1"
  description = "PM Service uri. Endpoint to retrieve Payment Instruments information."
}

variable "pm_backend_url" {
  type        = string
  description = "Payment manager backend url (enrollment)"
}

variable "mil_openid_url" {
  type        = string
  description = "OpenId MIL url"
}

variable "mil_issuer_url" {
  type        = string
  description = " MIL issuer url"
}

variable "webViewUrl" {
  type        = string
  description = "WebView Url"
}

variable "pm_timeout_sec" {
  type        = number
  description = "Payment manager timeout (sec)"
  default     = 5
}


#
# Storage Account
#
variable "storage_account_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa"
  default     = "LRS"
}

variable "storage_delete_retention_days" {
  type        = number
  description = "Number of days to retain deleted files"
  default     = 5
}

variable "storage_enable_versioning" {
  type        = bool
  description = "Enable versioning"
  default     = false
}

variable "storage_advanced_threat_protection" {
  type        = bool
  description = "Enable threat advanced protection"
  default     = false
}

variable "storage_public_network_access_enabled" {
  type        = bool
  description = "Enable public network access"
  default     = false
}

#
# RTD reverse proxy
#
variable "reverse_proxy_rtd" {
  type        = string
  default     = "127.0.0.1"
  description = "AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller."
}

#
# SMTP Server
#
variable "mail_server_host" {
  type        = string
  description = "SMTP server hostname"
}

variable "mail_server_port" {
  type        = string
  default     = "587"
  description = "SMTP server port"
}

variable "mail_server_protocol" {
  type        = string
  default     = "smtp"
  description = "mail protocol"
}

variable "idpay_mocked_merchant_enable" {
  type        = bool
  description = "Enable mocked merchant APIs"
  default     = false
}

variable "idpay_mocked_acquirer_apim_user_id" {
  type        = string
  description = "APIm user id of mocked acquirer"
  default     = null
}

variable "aks_cluster_domain_name" {
  type        = string
  description = "Name of the aks cluster domain. eg: dev01"
}

variable "enable" {
  type = object({
    mock_io_api = bool
  })
  description = "Feature flags"
  default = {
    mock_io_api = false
  }
}

variable "rate_limit_io_product" {
  type        = number
  description = "Rate limit for IO product"
  default     = 2500
}

variable "rate_limit_issuer_product" {
  type        = number
  description = "Rate limit for Issuer product"
  default     = 2000
}

variable "rate_limit_assistance_product" {
  type        = number
  description = "Rate limit for Assistance product"
  default     = 1000
}

variable "rate_limit_mil_citizen_product" {
  type        = number
  description = "Rate limit for MIL citizen product"
  default     = 2000
}

variable "rate_limit_mil_merchant_product" {
  type        = number
  description = "Rate limit for MIL merchant product"
  default     = 2000
}

variable "rate_limit_minint_product" {
  type        = number
  description = "Rate limit for MIN INT product"
  default     = 1000
}

variable "rate_limit_portal_product" {
  type        = number
  description = "Rate limit for institutions portal product"
  default     = 2500
}

variable "rate_limit_merchants_portal_product" {
  type        = number
  description = "Rate limit for merchants portal product"
  default     = 2500
}
