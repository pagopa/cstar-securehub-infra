prefix                = "cstar"
env_short             = "p"
env                   = "prod"
location              = "italynorth"
location_display_name = "Italy North"
location_short        = "itn"
domain                = "platform"

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

#
# Dns
#
dns_zone_internal_prefix = "internal"
external_domain          = "pagopa.it"
mcshared_dns_zone_prefix = "api-mcshared"

## Postgres
keycloak_pgflex_params = {
  enabled                                = true
  idh_resource_tier                      = "pgflex2"
  geo_replication_enabled                = false
  zone                                   = 1
  pgres_flex_pgbouncer_enabled           = false
  pgres_flex_diagnostic_settings_enabled = false
}

keycloak_configuration = {
  replica_count_min                           = 3
  replica_count_max                           = 5
  http_client_connection_ttl_millis           = 180000
  http_client_connection_max_idle_time_millis = 360000
}
