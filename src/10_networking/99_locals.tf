locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product          = "${var.prefix}-${var.env_short}"
  product_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"

  tags_for_private_dns = { "PrivateDns" = "true" }

  ### 🏷️ Tags
  tags_for_mc = merge(var.tags, {
    "domain" = "mc"
  })

  # VNET
  vnet_name                = "${local.project}-vnet"
  vnet_resource_group_name = "${local.project}-vnet-rg"

  vnet_weu_core = {
    name           = "${var.prefix}-${var.env_short}-vnet"
    resource_group = "${var.prefix}-${var.env_short}-vnet-rg"
  }

  vnet_weu_aks = {
    name           = "${var.prefix}-${var.env_short}-weu-${var.env}01-vnet"
    resource_group = "${var.prefix}-${var.env_short}-weu-${var.env}01-vnet-rg"
  }

  #
  # KV
  #
  kv_core_name                = "${local.project}-kv"
  kv_core_resource_group_name = "${local.project}-sec-rg"

  #
  # Packer
  #
  packer_rg_name = "${local.product}-${var.location_short}-packer-rg"
}
