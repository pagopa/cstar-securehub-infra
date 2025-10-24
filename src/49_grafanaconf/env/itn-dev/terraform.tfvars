prefix                = "cstar"
env_short             = "d"
env                   = "dev"
location              = "italynorth"
location_display_name = "Italy North"
location_short        = "itn"
domain                = "platform"

team_groups = {
  idpay = {
    "cstar-d-idpay-adgroup-admin" = {
      permission = "Admin"
    }
    "cstar-d-idpay-adgroup-developers" = {
      permission = "Edit"
    }
    "cstar-d-idpay-adgroup-externals" = {
      permission = "Edit"
    }
  }
  srtp = {
    "cstar-d-srtp-adgroup-admin" = {
      permission = "Admin"
    }
    "cstar-d-srtp-adgroup-developers" = {
      permission = "Edit"
    }
    "cstar-d-srtp-adgroup-externals" = {
      permission = "Edit"
    }
  }
}

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}
