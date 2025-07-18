locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"
  project_core     = "${var.prefix}-${var.env_short}-${var.location_short}-core"
  product          = "${var.prefix}-${var.env_short}"

  # Default Domain Resource Group
  data_rg_name     = "${local.project}-data-rg"
  security_rg_name = "${local.project}-security-rg"
  compute_rg_name  = "${local.project}-compute-rg"
  cicd_rg_name     = "${local.project}-cicd-rg"
  monitor_rg_name  = "${local.project}-monitoring-rg"

  # APIM
  apim_name    = "${local.product}-apim"
  apim_rg_name = "${local.product}-api-rg"

  default_resourge_group_names = [
    local.data_rg_name,
    local.security_rg_name,
    local.compute_rg_name,
    local.cicd_rg_name,
    local.monitor_rg_name
  ]

  #
  # 🌐 Network
  #
  vnet_core_rg_name       = "${local.product}-vnet-rg"
  network_rg              = "${local.project_core}-network-rg"
  vnet_spoke_data_rg_name = "${local.project_core}-network-rg"
  vnet_spoke_data_name    = "${local.project_core}-spoke-data-vnet"
  vnet_spoke_compute_name = "${local.project_core}-spoke-compute-vnet"

  # KeyVault
  general_kv_name = "${local.project_nodomain}-mc-gen-kv"
  auth_kv_name    = "${local.project_nodomain}-mc-auth-kv"

  revoked_refresh_tokens_ttl = 7776000

  repositories = ["mil-auth"]
}
