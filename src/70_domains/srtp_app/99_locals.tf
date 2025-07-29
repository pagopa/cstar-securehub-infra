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

  # APIM
  apim_rg_name = "cstar-${var.env_short}-api-rg"
  apim_name    = "cstar-${var.env_short}-apim"

  # PLATFORM GITHUB Container Apps Environment
  github_cae_name = "${local.product}-platform-github-cae"
  github_cae_rg   = "${local.product}-platform-compute-rg"
}
