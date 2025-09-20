locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"
  product          = "${var.prefix}-${var.env_short}"

  key_vaults = {
    core  = "${local.project}-kv"
    auth  = "${local.project}-auth-kv"
    idpay = "${local.project}-idpay-kv"
  }

  secrets_folder    = "mdc"
  config_input_file = var.input_file
  secrets_base_path = "secrets/${local.secrets_folder}/${var.location_short}-${var.env}"

  tags = merge(
    {
      CreatedBy   = "Terraform"
      Environment = upper(var.env)
      Owner       = "CSTAR"
      Source      = "https://github.com/pagopa/cstar-securehub-infra"
      CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
      Folder      = basename(abspath(path.module))
    },
    var.tags
  )
}
