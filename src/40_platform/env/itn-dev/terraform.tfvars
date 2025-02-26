prefix                    = "cstar"
env_short                 = "d"
env                       = "dev"
location                  = "italynorth"
location_short            = "itn"
domain                    = "platform"

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

#
# Networking
#
### 10.90.0.0
cidr_subnet_synthetic_cae         = ["10.90.0.0/24"]
### 10.90.1.0/24
cidr_subnet_storage_private_endpoints = ["10.90.1.0/27"]

#
# Monitoring
#
monitoring_law_sku                    = "PerGB2018"
monitoring_law_retention_in_days      = 30
monitoring_law_daily_quota_gb         = 10

### Synthetic
synthetic_storage_account_replication_type = "LRS"
synthetic_alerts_enabled                   = false
