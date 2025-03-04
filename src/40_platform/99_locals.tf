locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product          = "${var.prefix}-${var.env_short}"
  product_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"

  #
  # Network
  #
  vnet_rg_name            = "${local.product_nodomain}-core-network-rg"
  vnet_core_platform_name = "${local.product_nodomain}-core-spoke-platform-vnet"

  legacy_vnet_core_rg_name      = "${local.product}-vnet-rg"
  dns_privatelink_storage_table = "privatelink.table.core.windows.net"

  monitor_resource_group_name  = "${local.product_nodomain}-core-monitor-rg"
  log_analytics_workspace_name = "${local.product_nodomain}-core-law"

  #
  # KV
  #
  kv_cicd_name                = "${local.product_nodomain}-cicd-kv"
  kv_cicd_resource_group_name = "${local.product_nodomain}-core-sec-rg"

  #
  # Domain urls
  #
  public_domain_suffix           = var.env == "prod" ? "cstar.pagopa.it" : "${var.env}.cstar.pagopa.it"
  internal_private_domain_suffix = var.env == "prod" ? "internal.cstar.pagopa.it" : "internal.${var.env}.cstar.pagopa.it"

}
