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
azdo_agent_image_version = "v20250518"
enable_azdoa             = true

enable_ses = true
dkim_records = {
  "qgx2omswenpdxv42ixhiwbljtq3modhc._domainkey.dev.cstar.pagopa.it" = "qgx2omswenpdxv42ixhiwbljtq3modhc.dkim.amazonses.com"
  "f4bpkk5mq33ro6qevgsg675q56zqoxbx._domainkey.dev.cstar.pagopa.it" = "f4bpkk5mq33ro6qevgsg675q56zqoxbx.dkim.amazonses.com"
  "hcmqrzg2mtpmi6e4dn55tepzvtv3zsoo._domainkey.dev.cstar.pagopa.it" = "hcmqrzg2mtpmi6e4dn55tepzvtv3zsoo.dkim.amazonses.com"
}
