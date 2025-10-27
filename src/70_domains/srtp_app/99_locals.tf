locals {
  # General
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}-${var.location_short}"

  # Default Domain Resource Group
  data_rg       = "${local.project}-data-rg"
  security_rg   = "${local.project}-security-rg"
  compute_rg    = "${local.project}-compute-rg"
  cicd_rg       = "${local.project}-cicd-rg"
  monitoring_rg = "${local.project}-monitoring-rg"
  identities_rg = "${local.project}-identity-rg"


  # 🔐 KV
  key_vault_name    = "${local.project}-kv"
  key_vault_rg_name = "${local.project}-security-rg"

  # Storage Account
  srtp_storage_account_name = "${local.project}-sa"
  srtp-jks-storage-account-name = "${local.project}-share-sa"

  # APIM
  apim_rg_name = "cstar-${var.env_short}-api-rg"
  apim_name    = "cstar-${var.env_short}-apim"

  # PLATFORM GITHUB Container Apps Environment
  github_cae_name = "${local.product}-platform-github-cae"
  github_cae_rg   = "${local.product}-platform-compute-rg"

  # AKS
  aks_name                = "${local.product}-${var.env}-aks"
  aks_resource_group_name = "${local.product}-core-aks-rg"

  # 🔎 DNS
  dns_zone_name     = var.env != "prod" ? "${var.env}.${var.prefix}.pagopa.it" : "${var.prefix}.pagopa.it"
  dns_zone_internal = "internal.${local.dns_zone_name}"
  ingress_hostname  = "${var.domain}.${var.location_short}.${local.dns_zone_internal}"

  # Workload Identity
  secret_name_workload_identity_client_id            = "${var.domain}-${var.location_short}-workload-identity-client-id"
  secret_name_workload_identity_service_account_name = "${var.domain}-${var.location_short}-workload-identity-service-account-name"
  secret_name_workload_identity         = "${var.domain}-${var.location_short}-workload-identity"

  ### ARGOCD
  argocd_namespace    = "argocd"
  argocd_internal_url = "argocd.${var.location_short}.${local.dns_zone_internal}"
}
