variable "datavault_service_url_for_uat" {
  type        = string
  description = "URL of the datavault service for UAT environment."
}

variable "subscription_id_for_uat" {
  type        = string
  description = "Subscription ID of the UAT environment, retrieved dynamically."
}

variable "argocd_server_for_prod" {
  type        = string
  description = "Server of the ArgoCD server for PROD environment."
}

variable "argocd_server_for_uat" {
  type        = string
  description = "Server of the ArgoCD server for UAT environment."
}
