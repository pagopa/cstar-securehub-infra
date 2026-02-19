locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"
  product          = "${var.prefix}-${var.env_short}"
  product_domain   = "${var.prefix}-${var.env_short}-${var.domain}"

  # these are the folder names inside the secrets folder in idpay_security
  secrets_folders_kv = ["mdc"] // e.g. ["core", "cicd"]

  # AZDO
  azdo_managed_identity_rg_name = "${var.prefix}-${var.env_short}-identity-rg"
  azdo_iac_managed_identities_read = [
    "azdo-${var.env}-${var.prefix}-iac-plan-v2",
    "azdo-${var.env}-${var.prefix}-app-plan-v2",
  ]

  azdo_iac_managed_identities_write = [
    "azdo-${var.env}-${var.prefix}-iac-deploy-v2",
    "azdo-${var.env}-${var.prefix}-app-deploy-v2"
  ]
}
