prefix                = "cstar"
env_short             = "u"
env                   = "uat"
location              = "italynorth"
location_display_name = "Italy North"
location_short        = "itn"
domain                = "platform"

team_groups = {
  idpay = {
    "cstar-u-idpay-adgroup-admin" = {
      permission = "Admin"
    }
    "cstar-u-idpay-adgroup-developers" = {
      permission = "View"
    }
    "cstar-u-idpay-adgroup-externals" = {
      permission = "View"
    }
  }
  srtp = {
    "cstar-u-srtp-adgroup-admin" = {
      permission = "Admin"
    }
    "cstar-u-srtp-adgroup-developers" = {
      permission = "View"
    }
    "cstar-u-srtp-adgroup-externals" = {
      permission = "View"
    }
  }
}

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}
