locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product          = "${var.prefix}-${var.env_short}"
  product_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"

  azdo_managed_identity_rg_name = "${local.product_nodomain}-core-identity-rg"
  azdo_iac_managed_identities   = toset(["azdo-${var.env}-p4pa-iac-deploy", "azdo-${var.env}-p4pa-iac-plan"])
}
