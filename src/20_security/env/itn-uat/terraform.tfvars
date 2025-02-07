# general
prefix         = "p4pa"
env_short      = "u"
env            = "uat"
domain         = "uat"
location       = "italynorth"
location_short = "itn"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "P4PA"
  Source      = "https://github.com/pagopa-p4pa/p4pa-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

input_file = "./secret/itn-uat/configs.json"