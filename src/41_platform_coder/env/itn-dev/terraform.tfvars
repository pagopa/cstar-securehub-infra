prefix                = "cstar"
env_short             = "d"
env                   = "dev"
location              = "italynorth"
location_display_name = "Italy North"
location_short        = "itn"
domain                = "platform"

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

#
# Dns
#
dns_zone_internal_prefix = "internal.dev"
external_domain          = "pagopa.it"
mcshared_dns_zone_prefix = "api-mcshared.dev"

## Postgres
keycloak_pgflex_params = {
  enabled                                = true
  idh_resource_tier                      = "pg_burst_flex2"
  geo_replication_enabled                = false
  pgres_flex_pgbouncer_enabled           = false
  pgres_flex_diagnostic_settings_enabled = false
}

keycloak_configuration = {
  replica_count_min = 2
  replica_count_max = 3
}
