prefix          = "cstar"
env_short       = "p"
env             = "prod"
domain          = "idpay"
location        = "italynorth"
location_string = "Italy North"
location_short  = "itn"
instance        = "prod01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### External resources

monitor_resource_group_name                 = "cstar-p-monitor-rg"
log_analytics_workspace_name                = "cstar-p-law"
log_analytics_workspace_resource_group_name = "cstar-p-monitor-rg"

### Aks

aks_name                = "cstar-p-itn-prod01-aks"
aks_resource_group_name = "cstar-p-itn-prod01-aks-rg"
aks_vmss_name           = "aks-cstprod01usr-18685956-vmss"
aks_cluster_domain_name = "prod01"

ingress_load_balancer_ip = "10.11.100.250"
ingress_domain_hostname  = "idpay.itn.internal.cstar.pagopa.it"
reverse_proxy_be_io      = "10.1.0.250"

#
# Dns
#
dns_zone_internal_prefix = "internal.cstar"
external_domain          = "pagopa.it"

#
# Enable components
#
enable = {
  idpay = {
    eventhub = true
  }
  mock_io_api = false
}

#
# PDV
#
pdv_tokenizer_url = "https://api.tokenizer.pdv.pagopa.it/tokenizer/v1"
pdv_timeout_sec   = 5

#
# PM
#
pm_service_base_url = "https://api-io.cstar.pagopa.it"
pm_backend_url      = "https://api.platform.pagopa.it"

#
# MIL
#
#TODO: TO CHANGE
openid_config_url_mil = "https://mil-u-apim.azure-api.net/mil-auth/.well-known/openid-configuration"
mil_openid_url        = "https://api-mcshared.cstar.pagopa.it/auth/.well-known/openid-configuration"
mil_issuer_url        = "https://api-mcshared.cstar.pagopa.it/auth"

#
# WEBVIEW
#
webViewUrl = "https://api-io.cstar.pagopa.it/idpay/self-expense/login"

#
# Check IBAN
#
checkiban_base_url = "https://bankingservices.pagopa.it"

#
# SelfCare API
#
selc_base_url = "https://api.selfcare.pagopa.it"

#
# BE IO API
#
io_manage_backend_base_url = "https://api.io.pagopa.it"
# STUB: "https://api-io.cstar.pagopa.it/idpay/mock"

#
# ONE TRUST API
#
one_trust_privacynotice_base_url = "https://app-de.onetrust.com/api/privacynotice/v2"

# Storage
storage_account_replication_type      = "RAGZRS"
storage_delete_retention_days         = 90
storage_enable_versioning             = true
storage_advanced_threat_protection    = true
storage_public_network_access_enabled = false

#
# RTD reverse proxy
#
reverse_proxy_rtd = "10.1.0.250"

#
# SMTP Server
#
mail_server_host     = "smtp.gmail.com"
mail_server_port     = "465"
mail_server_protocol = "smtps"

idpay_alert_enabled = true

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
