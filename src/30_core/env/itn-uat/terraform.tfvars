prefix                = "cstar"
env_short             = "u"
env                   = "uat"
location              = "italynorth"
location_short        = "itn"
domain                = "core"
pagopa_location_short = "weu"

## Monitor
law_daily_quota_gb = 10

# Apim
apim_publisher_name = "CSTAR UAT"
apim_sku            = "Developer_1"
apim_alerts_enabled = false

# Domains
external_domain = "pagopa.it"
dns_zone_prefix = "uat.cstar"

# Application Gateway
app_gateway_sku_name              = "Standard_v2"
app_gateway_sku_tier              = "Standard_v2"
app_gateway_mtls_endpoint_enabled = true

# AZDOA:
enable_azdoa             = true
azdo_agent_image_version = "v20250519"
azdo_agent_perf_vm_sku   = "Standard_D16ads_v5"
