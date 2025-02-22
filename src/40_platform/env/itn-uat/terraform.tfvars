prefix                    = "cstar"
env_short                 = "u"
env                       = "uat"
location                  = "italynorth"
location_short            = "itn"
domain                    = "platform"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

#
# Networking
#
cidr_subnet_synthetic         = ["10.90.0.0/24"]

#
# Monitoring
#
monitoring_law_sku                    = "PerGB2018"
monitoring_law_retention_in_days      = 30
monitoring_law_daily_quota_gb         = 10

### Synthetic
synthetic_storage_account_replication_type = "ZRS"
synthetic_alerts_enabled                   = false

