locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}" // e.g. "cstar-dev-ny-app.com"
  project_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"               // e.g. "cstar-dev-ny"
  product          = "${var.prefix}-${var.env_short}"                                     // e.g. "cstar-dev"

  azdo_managed_identity_rg_name = "${local.product}-identity-rg"
  azdo_managed_identity_name    = upper("${var.env}-${var.prefix}")

  # this are the folder names inside the secrets folder in idpay_security
  secrets_folders_kv = ["idpay"] // e.g. ["core", "cicd"]

  apim_name                = "${local.product}-apim"
  apim_resource_group_name = "${local.product}-api-rg"

}
