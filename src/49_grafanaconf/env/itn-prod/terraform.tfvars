prefix                = "cstar"
env_short             = "p"
env                   = "prod"
location              = "italynorth"
location_display_name = "Italy North"
location_short        = "itn"
domain                = "platform"

team_groups = {
  idpay = {
    "cstar-p-idpay-adgroup-admin" = {
      permission = "Admin"
    }
    "cstar-p-idpay-adgroup-developers" = {
      permission = "View"
    }
    "cstar-p-idpay-adgroup-externals" = {
      permission = "View"
    }
    "cstar-p-idpay-adgroup-oncall" = {
      permission = "View"
    }
    "cstar-p-idpay-adgroup-project-managers" = {
      permission = "View"
    }
  }
  srtp = {
    "cstar-p-srtp-adgroup-admin" = {
      permission = "Admin"
    }
    "cstar-p-srtp-adgroup-developers" = {
      permission = "View"
    }
    "cstar-p-srtp-adgroup-externals" = {
      permission = "View"
    }
    "cstar-p-srtp-adgroup-project-managers" = {
      permission = "View"
    }
  }
}

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}
