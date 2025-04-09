# general
prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "idpay"
location       = "italynorth"
location_short = "itn"

tags = {
  CreatedBy    = "Terraform"
  Environment  = "UAT"
  Owner        = "CSTAR"
  Source       = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter   = "TS310 - PAGAMENTI & SERVIZI"
  BusinessUnit = "CStar"
  domain       = "idpay"
}

input_file = "./secret/itn-uat/configs.json"
