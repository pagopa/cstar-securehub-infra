locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product          = "${var.prefix}-${var.env_short}"
  product_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"

  #
  # Network
  #
  vnet_rg_name                = "${local.product_nodomain}-core-network-rg"
  vnet_core_platform_name                = "${local.product_nodomain}-core-spoke-platform-vnet"

  monitor_resource_group_name  = "${local.product_nodomain}-core-monitor-rg"
  log_analytics_workspace_name = "${local.product_nodomain}-core-law"
}
