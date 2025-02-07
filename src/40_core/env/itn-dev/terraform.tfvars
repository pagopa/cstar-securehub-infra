prefix                = "p4pa"
env_short             = "d"
env                   = "dev"
location              = "italynorth"
location_short        = "itn"
domain                = "core"
pagopa_location_short = "weu"

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "P4PA"
  Source      = "https://github.com/pagopa/p4pa-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### Monitor
law_daily_quota_gb = 10

### Apim
apim_publisher_name = "pagoPA Platform DEV"
apim_sku            = "Developer_1"
apim_alerts_enabled = false
external_domain     = "pagopa.it"
dns_zone_prefix     = "dev.p4pa"

### Application Gateway
app_gateway_api_certificate_name        = "api-dev-p4pa-pagopa-it"
app_gateway_api_mtls_certificate_name   = "api-mtls-dev-p4pa-pagopa-it"
app_gateway_portal_certificate_name     = "portal-dev-p4pa-pagopa-it"
app_gateway_management_certificate_name = "management-dev-p4pa-pagopa-it"
app_gateway_sku_name                    = "Standard_v2"
app_gateway_sku_tier                    = "Standard_v2"
app_gateway_alerts_enabled              = false
app_gateway_mtls_endpoint_enabled       = false

### AZDO
azdo_agent_image_version = "v20241219"
