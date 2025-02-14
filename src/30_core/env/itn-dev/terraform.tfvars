prefix                = "cstar"
env_short             = "d"
env                   = "dev"
location              = "italynorth"
location_short        = "itn"
domain                = "core"
pagopa_location_short = "weu"

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### Monitor
law_daily_quota_gb = 10

### AZDO
azdo_agent_image_version = "v20250212"
enable_azdoa             = true
