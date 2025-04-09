# general
prefix         = "cstar"
env_short      = "p"
env            = "prod"
domain         = "idpay"
location       = "italynorth"
location_short = "itn"

tags = {
  CreatedBy    = "Terraform"
  Environment  = "PROD"
  Owner        = "CSTAR"
  Source       = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter   = "TS310 - PAGAMENTI & SERVIZI"
  BusinessUnit = "CStar"
  domain       = "idpay"
}

input_file = "./secret/itn-prod/configs.json"
