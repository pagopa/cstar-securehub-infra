locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}" // e.g. "cstar-dev-ny-app.com"
  project_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"               // e.g. "cstar-dev-ny"
  product          = "${var.prefix}-${var.env_short}"                                     // e.g. "cstar-dev"

  azdo_managed_identity_rg_name = "${local.project_nodomain}-core-identity-rg"                                  // e.g. "cstar-dev-ny-core-identity-rg"
  azdo_iac_managed_identities   = toset(["azdo-${var.env}-cstar-iac-deploy", "azdo-${var.env}-cstar-iac-plan"]) // e.g. ["azdo-dev-cstar-iac-deploy", "azdo-dev-cstar-iac-plan"]

  # this are the folder names inside the secrets folder in idpay_security
  secrets_folders_kv = ["idpay"] // e.g. ["core", "cicd"]

}
