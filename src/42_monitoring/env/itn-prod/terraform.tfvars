prefix                    = "cstar"
env_short                 = "p"
env                       = "prod"
location                  = "italynorth"
location_short            = "itn"
location_westeurope       = "westeurope"
location_short_westeurope = "weu"
domain                    = "monitoring"

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### Grafana
grafana_zone_redundancy_enabled = true
grafana_major_version           = 10
