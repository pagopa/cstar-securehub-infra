locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}"


  subscription_name = "${var.env}-${var.prefix}"

  azdo_managed_identity_rg_name = "cstar-${var.env_short}-identity-rg"
  azdo_iac_managed_identities   = toset(["azdo-${var.env}-${var.prefix}-iac-deploy-v2", "azdo-${var.env}-${var.prefix}-iac-plan-v2"])

}
