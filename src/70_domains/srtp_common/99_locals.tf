locals {
  project      = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"
  product      = "${var.prefix}-${var.env_short}"

  # Default Domain Resource Group
  data_rg     = "${local.project}-data-rg"
  security_rg = "${local.project}}-security-rg"
  compute_rg  = "${local.project}}-compute-rg"
  cicd_rg     = "${local.project}}-cicd-rg"

  # Default Core Resource Group
  network_rg = "${local.project_core}-network-rg"

  # Default Core Network
  vnet_spoke_data_name = "${local.project_core}-spoke-data-vnet"

  # Legacy Resource
  vnet_legacy_core_rg_name = "${local.product}-vnet-rg"
}
