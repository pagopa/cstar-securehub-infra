locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}"

  # AZDO
  azdo_managed_identity_rg_name = "${local.product}-identity-rg"

  azdo_iac_managed_identities_read = toset([
    "azdo-${var.env}-${var.prefix}-iac-plan-v2",
    "azdo-${var.env}-${var.prefix}-app-plan-v2",
  ])

  azdo_iac_managed_identities_write = toset([
    "azdo-${var.env}-${var.prefix}-iac-deploy-v2",
    "azdo-${var.env}-${var.prefix}-app-deploy-v2"
  ])

  input_file = "./secrets/${var.domain}/${var.location_short}-${var.env}"
}
