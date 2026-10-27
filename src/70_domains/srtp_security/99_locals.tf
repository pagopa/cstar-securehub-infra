locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}" // e.g. "cstar-dev-ny-app.com"
  project_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"               // e.g. "cstar-dev-ny"
  product          = "${var.prefix}-${var.env_short}"                                     // e.g. "cstar-dev"
  project_entra    = "${var.prefix}-${var.env_short}-${var.domain}"

  # TODO create dedicated uid
  # this are the folder names inside the secrets folder in srtp_security
  secrets_folders_kv = ["srtp"] // e.g. ["core", "cicd"]

  input_file = "./secrets/${var.domain}/${var.location_short}-${var.env}"

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

  azdo_iac_read_kv = {
    for i in flatten([
      for identity in local.azdo_iac_managed_identities_read : [
        for kv in local.secrets_folders_kv : {
          key      = "${identity}@${kv}"
          identity = identity
          kv       = kv
        }
      ]
    ]) : i.key => i
  }

  azdo_iac_write_kv = {
    for i in flatten([
      for identity in local.azdo_iac_managed_identities_write : [
        for kv in local.secrets_folders_kv : {
          key      = "${identity}@${kv}"
          identity = identity
          kv       = kv
        }
      ]
    ]) : i.key => i
  }

}
