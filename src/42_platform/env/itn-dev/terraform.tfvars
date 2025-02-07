prefix         = "p4pa"
env_short      = "d"
env            = "dev"
location       = "italynorth"
location_short = "itn"
domain         = "platform"

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "P4PA"
  Source      = "https://github.com/pagopa/p4pa-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

#
# Network
#
cidr_postgres_subnet = ["10.1.131.0/27"] # 10.1.131.0 --> 10.1.130.31

#
# Dns
#
external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.dev.p4pa"

#
# CosmosDB
#
cosmos_cassandra_account_params = {
  enabled      = true
  capabilities = ["EnableCassandra"]
  offer_type   = "Standard"
  consistency_policy = {
    consistency_level       = "Strong"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
  # server_version                   = "6.0" # Set from console
  main_geo_location_zone_redundant = true
  enable_free_tier                 = false
  additional_geo_locations         = []

  private_endpoint_enabled                     = true
  public_network_access_enabled                = false
  is_virtual_network_filter_enabled            = true
  backup_continuous_enabled                    = false
  enable_provisioned_throughput_exceeded_alert = false
  ip_range_filter                              = "104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26,13.88.56.148,40.91.218.243,13.91.105.215,4.210.172.107,40.80.152.199,13.95.130.121,20.245.81.54,40.118.23.126"
}

#
# Temporal.io
#
temporal_io_postgres_schema_version    = "v1.14"
temporal_io_docker_admin_tools_version = "temporalio/admin-tools:1.25.2-tctl-1.18.1-cli-1.1.1"

## Postgres
temporal_pgflex_params = {
  enabled    = true
  sku_name   = "B_Standard_B2s"
  db_version = "15"
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

#
# Artemis
#
artemis_config = {
  chart_version              = "0.9.0"
  image_repository           = "apache/activemq-artemis"
  image_tag                  = "2.38.0"
  replica_count              = 1
  high_availability          = false
  persistence                = true
  storage_class              = "default-zrs"
  access_mode                = "ReadWriteOnce"
  storage_size               = "10Gi"
  management_console_enabled = true
}

#
# Subnets
#

aks_cidr_user_subnet = ["10.1.1.0/24"]
