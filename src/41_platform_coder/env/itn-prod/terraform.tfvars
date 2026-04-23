prefix         = "cstar"
env_short      = "p"
env            = "prod"
location       = "italynorth"
location_short = "itn"
domain         = "platform"

#
# Dns
#
dns_zone_internal_prefix = "internal"
external_domain          = "pagopa.it"
mcshared_dns_zone_prefix = "api-mcshared"

## Postgres
keycloak_pgflex_params = {
  enabled                                = true
  idh_resource_tier                      = "pgflex4"
  geo_replication_enabled                = false
  zone                                   = 1
  pgres_flex_pgbouncer_enabled           = false
  pgres_flex_diagnostic_settings_enabled = false
  auto_grow_enabled                      = true
  storage_tier                           = "P30"
}

keycloak_configuration = {
  image_registry                              = "public.ecr.aws"
  image_repository                            = "bitnami/keycloak"
  image_tag                                   = "26.6.1-debian-12-r0"
  chart_version                               = "24.7.7"
  replica_count_min                           = 2
  replica_count_max                           = 2
  cpu_request                                 = "3"
  cpu_limit                                   = "7"
  memory_request                              = "4Gi"
  memory_limit                                = "6Gi"
  http_client_connection_ttl_millis           = 180000
  http_client_connection_max_idle_time_millis = 180000
  image_registry_config_cli                   = "public.ecr.aws"
  image_repository_config_cli                 = "bitnami/keycloak-config-cli"
  image_tag_config_cli                        = "6.4.0"
}

aks_user_node_pool_keycloak = {
  idh_resource_tier = "Standard_D8ds_v5_active"
  node_count_min    = 2
  node_count_max    = 2
  os_disk_size_gb   = 300
  os_disk_type      = "Managed"
}

it_wallet_oid4vp_provider = {
  enabled = false
  credential_type                         = "urn:eudi:pid:it:1"
  user_mapping_claim                      = "tax_id_code"
  x509_certificate_pem_secret_name        = "__TODO_IT_WALLET_X509_CERTIFICATE_PEM_SECRET_NAME__"
  trust_list_url                          = "__TODO_IT_WALLET_TRUST_LIST_URL__"
  trust_list_lote_type                    = "__TODO_IT_WALLET_TRUST_LIST_LOTE_TYPE__"
  trust_list_signing_cert_pem_secret_name = "__TODO_IT_WALLET_TRUST_LIST_SIGNING_CERT_PEM_SECRET_NAME__"
}
