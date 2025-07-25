prefix          = "cstar"
env_short       = "u"
env             = "uat"
domain          = "idpay"
location        = "italynorth"
location_string = "Italy North"
location_short  = "itn"
instance        = "uat01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### External resources

monitor_resource_group_name                 = "cstar-u-monitor-rg"
log_analytics_workspace_name                = "cstar-u-law"
log_analytics_workspace_resource_group_name = "cstar-u-monitor-rg"

### Aks

aks_name                = "cstar-u-itn-uat01-aks"
aks_resource_group_name = "cstar-u-itn-uat01-aks-rg"
aks_vmss_name           = "aks-cstuat01usr-39999986-vmss"
aks_cluster_domain_name = "uat01"

ingress_load_balancer_ip = "10.11.100.250"
ingress_domain_hostname  = "idpay.itn.internal.uat.cstar.pagopa.it"
reverse_proxy_be_io      = "10.1.0.250"

#
# Dns
#
dns_zone_internal_prefix = "internal.uat.cstar"
external_domain          = "pagopa.it"

#
# Enable components
#
enable = {
  idpay = {
    eventhub = true
  }
  mock_io_api = true
}

#
# PDV
#
pdv_tokenizer_url = "https://api.uat.tokenizer.pdv.pagopa.it/tokenizer/v1"
pdv_timeout_sec   = 5
#
# MIL
#
openid_config_url_mil = "https://mil-u-apim.azure-api.net/mil-auth/.well-known/openid-configuration"
mil_openid_url        = "https://api-mcshared.uat.cstar.pagopa.it/auth/.well-known/openid-configuration"
mil_issuer_url        = "https://api-mcshared.uat.cstar.pagopa.it/auth"

#
# WEBVIEW
#
webViewUrl = "https://api-io.uat.cstar.pagopa.it/idpay/self-expense/login"

#
# PM
#
pm_service_base_url = "https://api-io.uat.cstar.pagopa.it"
pm_backend_url      = "https://api.uat.platform.pagopa.it"

#
# Check IBAN
#
checkiban_base_url = "https://bankingservices-sandbox.pagopa.it"

#
# SelfCare API
#
selc_base_url = "https://api.uat.selfcare.pagopa.it"

#
# BE IO API
#
io_manage_backend_base_url = "https://api.io.pagopa.it" #"https://api-io.uat.cstar.pagopa.it/idpay/mock"

#
# ONE TRUST API
#
one_trust_privacynotice_base_url = "https://app-de.onetrust.com/api/privacynotice/v2"

# Storage
storage_delete_retention_days = 5
storage_enable_versioning     = true

#
# RTD reverse proxy
#
reverse_proxy_rtd = "10.1.0.250"

#
# SMTP Server
#
mail_server_host = "smtp.ethereal.email"

idpay_mocked_merchant_enable       = true
idpay_mocked_acquirer_apim_user_id = "rtd-uat-acquirer-pagopa-it"
idpay_alert_enabled                = true

#
# Rate limit
#
rate_limit_io_product               = 2500
rate_limit_issuer_product           = 2000
rate_limit_assistance_product       = 1000
rate_limit_mil_citizen_product      = 2000
rate_limit_mil_merchant_product     = 2000
rate_limit_minint_product           = 1000
rate_limit_portal_product           = 2500
rate_limit_merchants_portal_product = 2500
