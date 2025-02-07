prefix                    = "cstar"
env_short                 = "u"
env                       = "uat"
location                  = "italynorth"
location_short            = "itn"
location_westeurope       = "westeurope"
location_short_westeurope = "weu"
domain                    = "monitoring"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### Grafana
grafana_zone_redundancy_enabled = false
grafana_major_version           = 10
