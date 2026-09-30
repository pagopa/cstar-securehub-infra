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
  idh_resource_tier                      = "pgflex2"
  geo_replication_enabled                = false
  zone                                   = 2
  pgres_flex_pgbouncer_enabled           = false
  pgres_flex_diagnostic_settings_enabled = false
  auto_grow_enabled                      = false
}

keycloak_configuration = {
  image_registry                              = "public.ecr.aws"
  image_repository                            = "bitnami/keycloak"
  image_tag                                   = "26.6.1-debian-12-r0"
  chart_version                               = "24.7.7"
  replica_count_min                           = 1
  replica_count_max                           = 2
  cpu_request                                 = "500m"
  cpu_limit                                   = "1"
  memory_request                              = "1Gi"
  memory_limit                                = "2Gi"
  http_client_connection_ttl_millis           = 180000
  http_client_connection_max_idle_time_millis = 180000
  image_registry_config_cli                   = "docker.io"
  image_repository_config_cli                 = "adorsys/keycloak-config-cli"
  image_tag_config_cli                        = "6.4.0-26.1.0"
  image_digest_config_cli                     = "sha256:6795d2cbf9ed7c96e9d19c39781d383d12df36b5cbe81f0024bca4fa4d392681"
}

aks_user_node_pool_keycloak = {
  idh_resource_tier = "Standard_B4ms_active"
  node_count_min    = 1
  node_count_max    = 1
}

it_wallet_oid4vp_provider = {
  enabled                          = true
  credential_type                  = "urn:eudi:pid:it:1"
  user_mapping_claim               = "personal_administrative_number"
  x509_certificate_pem_secret_name = "itwallet-oid4vp-x509-certificate-pem"
  allowUntrustedX5cDevMode         = true
  // NOT REQUIRED FOR THE POC
  //trust_list_url                          = "__TODO_IT_WALLET_TRUST_LIST_URL__"
  //trust_list_lote_type                    = "__TODO_IT_WALLET_TRUST_LIST_LOTE_TYPE__"
  //trust_list_signing_cert_pem_secret_name = "__TODO_IT_WALLET_TRUST_LIST_SIGNING_CERT_PEM_SECRET_NAME__"
}
