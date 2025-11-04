prefix         = "cstar"
env_short      = "u"
env            = "uat"
location       = "italynorth"
location_short = "itn"
domain         = "platform"

#
# Dns
#
dns_zone_internal_prefix = "internal.uat"
external_domain          = "pagopa.it"
mcshared_dns_zone_prefix = "api-mcshared.uat"

## Postgres
keycloak_pgflex_params = {
  enabled                                = true
  idh_resource_tier                      = "pgflex8"
  geo_replication_enabled                = false
  zone                                   = 1
  pgres_flex_pgbouncer_enabled           = false
  pgres_flex_diagnostic_settings_enabled = false
  auto_grow_enabled                      = false
}

# TODO restore replicas to 2-3 after load test
keycloak_configuration = {
  image_registry                              = "docker.io"
  image_repository                            = "bitnamilegacy/keycloak"
  image_tag                                   = "26.3.1-debian-12-r1"
  chart_version                               = "24.7.7"
  replica_count_min                           = 1
  replica_count_max                           = 1
  cpu_request                                 = "3"
  cpu_limit                                   = "7"
  memory_request                              = "4Gi"
  memory_limit                                = "6Gi"
  http_client_connection_ttl_millis           = 180000
  http_client_connection_max_idle_time_millis = 180000
}

aks_user_node_pool_keycloak = {
  aks_user_node_pool_keycloak = "Standard_D8ads_v5_active"
  node_count_min              = 1
  node_count_max              = 1
  os_disk_size_gb             = 300
  os_disk_type                = "Managed"
}
