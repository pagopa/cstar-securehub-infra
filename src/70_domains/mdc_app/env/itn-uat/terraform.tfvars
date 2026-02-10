prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "mdc"
location       = "italynorth"
location_short = "itn"

# DNS
dns_zone_internal_prefix = "internal.uat.cstar"
external_domain          = "pagopa.it"

# Feature flags
enable = {}

# Rate limit
rate_limit_emd_product = 2000
rate_limit_emd_message = 9000

# Event hub
event_hub_port = 9093

# MIL
mdc_openid_url = "https://api-mcshared.uat.cstar.pagopa.it/auth/.well-known/openid-configuration"
mdc_issuer_url = "https://api-mcshared.uat.cstar.pagopa.it/auth"
