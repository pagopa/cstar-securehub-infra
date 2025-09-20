prefix          = "cstar"
env_short       = "p"
env             = "prod"
domain          = "mdc"
location        = "italynorth"
location_string = "Italy North"
location_short  = "itn"
instance        = "prod01"

tags = {
  CreatedBy    = "Terraform"
  Environment  = "PROD"
  Owner        = "CSTAR"
  Source       = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter   = "TS310 - PAGAMENTI & SERVIZI"
  BusinessUnit = "CStar"
  domain       = "mdc"
}

### Aks
aks_name                = "cstar-p-itn-prod01-aks"
aks_resource_group_name = "cstar-p-itn-prod01-aks-rg"
aks_cluster_domain_name = "prod01"

ingress_load_balancer_ip       = "10.20.0.250"
ingress_load_balancer_hostname = "mdc.itn.internal.cstar.pagopa.it"

# DNS
dns_zone_internal_prefix = "internal.cstar"
external_domain          = "pagopa.it"

# Feature flags
enable = {}

# Rate limit
rate_limit_emd_product = 2000
rate_limit_emd_message = 9000

# Event hub
event_hub_port = 9093

# MIL
mdc_openid_url = "https://api-mcshared.cstar.pagopa.it/auth/.well-known/openid-configuration"
mdc_issuer_url = "https://api-mcshared.cstar.pagopa.it/auth"
