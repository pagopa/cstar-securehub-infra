locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"
  project_core     = "${var.prefix}-${var.env_short}-${var.location_short}-core"
  product          = "${var.prefix}-${var.env_short}"


  # Default Domain Resource Group
  data_rg                     = "${local.project}-data-rg"
  security_rg                 = "${local.project}-security-rg"
  compute_rg                  = "${local.project}-compute-rg"
  cicd_rg                     = "${local.project}-cicd-rg"
  monitor_resource_group_name = "${local.project}-monitoring-rg"

  # 🛜 VNET + Subnets
  vnet_legacy_core_rg      = "${local.product}-vnet-rg"
  vnet_core_rg_name        = "${local.project_core}-network-rg"
  vnet_spoke_security_name = "${local.project_core}-spoke-security-vnet"

  secrets_folders_kv = ["gen", "auth"]
}
