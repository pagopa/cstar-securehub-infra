locals {
  product = "${var.prefix}-${var.env_short}"
  project = "${local.product}-${var.location_short}-${local.domain}"

  key_vault_name    = "${var.prefix}-${var.env_short}-kv"
  key_vault_rg_name = "${var.prefix}-${var.env_short}-sec-rg"

  domain = "tfaudit"
}
