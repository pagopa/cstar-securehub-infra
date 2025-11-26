locals {
  product = "${var.prefix}-${var.env_short}"
  project = "${local.product}-${var.location_short}-${local.domain}"

  key_vault_name    = "${var.prefix}-${var.env_short}-${var.location_short}-core-kv"
  key_vault_rg_name = "${var.prefix}-${var.env_short}-${var.location_short}-core-sec-rg"

  domain = "tfaudit"
}
