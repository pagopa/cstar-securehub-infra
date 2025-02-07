prefix                = "p4pa"
env_short             = "u"
env                   = "uat"
location              = "italynorth"
location_short        = "itn"
domain                = "core"
pagopa_location_short = "weu"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "P4PA"
  Source      = "https://github.com/pagopa/p4pa-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

## Monitor
law_daily_quota_gb = 10

# Apim
apim_publisher_name = "P4PA UAT"
apim_sku            = "Developer_1"
apim_alerts_enabled = false

# Domains
external_domain = "pagopa.it"
dns_zone_prefix = "uat.p4pa"

# Application Gateway
app_gateway_sku_name              = "Standard_v2"
app_gateway_sku_tier              = "Standard_v2"
app_gateway_mtls_endpoint_enabled = true

# AZDOA:
enable_azdoa             = true
azdo_agent_image_version = "v20241218"
