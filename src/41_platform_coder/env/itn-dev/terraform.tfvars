prefix         = "cstar"
env_short      = "d"
env            = "dev"
location       = "italynorth"
location_short = "itn"
domain         = "platform"

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
  zone                                   = 2
  pgres_flex_pgbouncer_enabled           = false
  pgres_flex_diagnostic_settings_enabled = false
  auto_grow_enabled                      = false
}

keycloak_configuration = {
  image_registry                              = "docker.io"
  image_repository                            = "bitnamilegacy/keycloak"
  image_tag                                   = "26.3.1-debian-12-r1"
  chart_version                               = "24.7.7"
  replica_count_min                           = 1
  replica_count_max                           = 2
  cpu_request                                 = "500m"
  cpu_limit                                   = "1"
  memory_request                              = "1Gi"
  memory_limit                                = "2Gi"
  http_client_connection_ttl_millis           = 180000
  http_client_connection_max_idle_time_millis = 180000
  image_registry_config_cli                   = "public.ecr.aws"
  image_repository_config_cli                 = "bitnami/keycloak-config-cli"
  image_tag_config_cli                        = "6.4.0"
}

aks_user_node_pool_keycloak = {
  idh_resource_tier = "Standard_B4ms_active"
  node_count_min    = 1
  node_count_max    = 1
}
