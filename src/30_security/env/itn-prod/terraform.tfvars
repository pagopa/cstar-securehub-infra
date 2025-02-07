# general
prefix         = "p4pa"
env_short      = "p"
env            = "prod"
domain         = "prod"
location       = "italynorth"
location_short = "itn"

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "P4PA"
  Source      = "https://github.com/pagopa-p4pa/p4pa-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

input_file = "./secret/itn-prod/configs.json"