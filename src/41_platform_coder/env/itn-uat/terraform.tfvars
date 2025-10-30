prefix                = "cstar"
env_short             = "u"
env                   = "uat"
location              = "italynorth"
location_display_name = "Italy North"
location_short        = "itn"
domain                = "platform"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

#
# Dns
#
dns_zone_internal_prefix = "internal.uat"
external_domain          = "pagopa.it"
mcshared_dns_zone_prefix = "api-mcshared.uat"

## Postgres
keycloak_pgflex_params = {
  enabled                                = true
  idh_resource_tier                      = "pgflex2"
  geo_replication_enabled                = false
  zone                                   = 1
  pgres_flex_pgbouncer_enabled           = false
  pgres_flex_diagnostic_settings_enabled = false
  auto_grow_enabled                      = false

}

keycloak_configuration = {
  image_registry                              = "docker.io"
  image_repository                            = "bitnamilegacy/keycloak"
  image_tag                                   = "26.3.1-debian-12-r1"
  chart_version                               = "24.7.7"
  replica_count_min                           = 3
  replica_count_max                           = 6
  cpu_request                                 = "1"
  cpu_limit                                   = "2"
  memory_request                              = "1.5Gi"
  memory_limit                                = "3Gi"
  http_client_connection_ttl_millis           = 180000
  http_client_connection_max_idle_time_millis = 180000
}
