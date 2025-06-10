# general
prefix         = "cstar"
env_short      = "p"
env            = "prod"
domain         = "srtp"
location       = "italynorth"
location_short = "itn"

tags = {
  CreatedBy    = "Terraform"
  Environment  = "PROD"
  Owner        = "CSTAR"
  Source       = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter   = "TS310 - PAGAMENTI & SERVIZI"
  BusinessUnit = "CStar"
  domain       = "srtp"
}

input_file = "./secret/itn-prod/configs.json"
