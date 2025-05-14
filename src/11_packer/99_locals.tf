locals {
  product          = "${var.prefix}-${var.env_short}"
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product_location = "${var.prefix}-${var.env_short}-${var.location_short}"

  network_core_italy_rg_name = "${local.product_location}-core-network-rg"
}
