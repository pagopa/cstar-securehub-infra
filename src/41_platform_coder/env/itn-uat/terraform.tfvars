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
  enabled    = true
  sku_name   = "B_Standard_B2s"
  db_version = "16"
  # Possible values are 32768, 65536, 131072, 262144, 524288, 1048576,
  # 2097152, 4194304, 8388608, 16777216, and 33554432.
  storage_mb                             = 32768
  zone                                   = 1
  backup_retention_days                  = 7
  geo_redundant_backup_enabled           = false
  create_mode                            = "Default"
  pgres_flex_private_endpoint_enabled    = true
  pgres_flex_ha_enabled                  = false
  pgres_flex_pgbouncer_enabled           = false
  pgres_flex_diagnostic_settings_enabled = false
  max_connections                        = 1700
  pgbouncer_min_pool_size                = 100
  pgbouncer_default_pool_size            = 100
}

keycloak_configuration = {
  replica_count_min = 1
  replica_count_max = 2
}
