#
# 🔒 KV
#
locals {
  idpay_postgres_database = "idpay-database"
  idpay_postgres_service_roles = var.idpay_pgflex_params.enabled ? {
    payment = {
      role_name            = "idpaydbpayment"
      user_secret_name     = "idpay-postgres-payment-user"
      password_secret_name = "idpay-postgres-payment-password"
    }
    transactions = {
      role_name            = "idpaydbtransactions"
      user_secret_name     = "idpay-postgres-transactions-user"
      password_secret_name = "idpay-postgres-transactions-password"
    }
    kafka_connect = {
      role_name            = "idpaydbkafkaconnect"
      user_secret_name     = "idpay-postgres-kafka-connect-user"
      password_secret_name = "idpay-postgres-kafka-connect-password"
    }
  } : {}
  idpay_postgres_flyway_schemas = var.idpay_pgflex_params.enabled ? {
    "idpay-pagamenti" = "payment"
    "idpay-rimborsi"  = "transactions"
  } : {}
}

resource "azurerm_key_vault_secret" "idpay_postgres_admin_user" {
  count        = var.idpay_pgflex_params.enabled ? 1 : 0
  name         = "idpay-postgres-admin-user"
  value        = "idpaydbadmin"
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  content_type = "text/plain"

  tags = module.tag_config.tags
}

resource "random_password" "idpay_postgres_admin_password" {
  count       = var.idpay_pgflex_params.enabled ? 1 : 0
  length      = 20
  special     = true
  min_special = 1
  # Limitiamo i caratteri speciali al solo "-"
  override_special = "-"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
}

resource "azurerm_key_vault_secret" "idpay_postgres_admin_password" {
  count        = var.idpay_pgflex_params.enabled ? 1 : 0
  name         = "idpay-postgres-admin-password"
  value        = random_password.idpay_postgres_admin_password[0].result
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  content_type = "text/plain"

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "idpay_postgres_service_user" {
  for_each = local.idpay_postgres_service_roles

  name         = each.value.user_secret_name
  value        = each.value.role_name
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  content_type = "text/plain"

  tags = module.tag_config.tags
}

resource "random_password" "idpay_postgres_service_password" {
  for_each = local.idpay_postgres_service_roles

  length      = 32
  special     = true
  min_special = 1
  # Limitiamo i caratteri speciali al solo "-"
  override_special = "-"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
}

resource "azurerm_key_vault_secret" "idpay_postgres_service_password" {
  for_each = local.idpay_postgres_service_roles

  name         = each.value.password_secret_name
  value        = random_password.idpay_postgres_service_password[each.key].result
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  content_type = "text/plain"

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "idpay_postgres_host" {
  count        = var.idpay_pgflex_params.enabled ? 1 : 0
  name         = "idpay-postgres-host"
  value        = module.idpay_pgflex[0].fqdn
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  content_type = "text/plain"

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "idpay_postgres_connection_string" {
  count        = var.idpay_pgflex_params.enabled ? 1 : 0
  name         = "idpay-postgres-connection-string"
  value        = "jdbc:postgresql://${module.idpay_pgflex[0].fqdn}:5432/${local.idpay_postgresql_database_name}"
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  content_type = "text/plain"

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "idpay_postgres_connection_string_r2dbc" {
  count        = var.idpay_pgflex_params.enabled ? 1 : 0
  name         = "idpay-postgres-connection-string-r2dbc"
  value        = "r2dbc:postgresql://${module.idpay_pgflex[0].fqdn}:5432/${local.idpay_postgresql_database_name}"
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  content_type = "text/plain"

  tags = module.tag_config.tags
}

module "idpay_pgflex" {
  count  = var.idpay_pgflex_params.enabled ? 1 : 0
  source = "./.terraform/modules/__v4__/IDH/postgres_flexible_server"

  # Basic server configuration
  name                = "${local.project}-pgflex"
  location            = data.azurerm_resource_group.idpay_data_rg.location
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name

  # Resource tier and environment settings
  idh_resource_tier = var.idpay_pgflex_params.idh_resource_tier
  product_name      = var.prefix
  env               = var.env
  databases         = [local.idpay_postgres_database]

  # Network configuration
  embedded_subnet = {
    enabled      = true
    vnet_name    = data.azurerm_virtual_network.vnet_spoke_data.name
    vnet_rg_name = data.azurerm_virtual_network.vnet_spoke_data.resource_group_name
  }
  private_dns_zone_id     = data.azurerm_private_dns_zone.postgres_flexible_privatelink.id
  resource_group_nsg_name = local.network_rg

  # Authentication configuration
  administrator_login    = azurerm_key_vault_secret.idpay_postgres_admin_user[0].value
  administrator_password = azurerm_key_vault_secret.idpay_postgres_admin_password[0].value

  # Monitoring and performance settings
  diagnostic_settings_enabled = var.idpay_pgflex_params.pgres_flex_diagnostic_settings_enabled
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.log_analytics_workspace.id
  private_dns_registration    = true
  private_dns_zone_name       = "${var.env_short}.internal.postgresql.cstar.pagopa.it"
  private_dns_zone_rg_name    = data.azurerm_resource_group.network_rg.name
  private_dns_record_cname    = "idpay-db"
  pg_bouncer_enabled          = var.idpay_pgflex_params.pgres_flex_pgbouncer_enabled
  zone                        = var.idpay_pgflex_params.zone

  auto_grow_enabled = var.idpay_pgflex_params.auto_grow_enabled
  # Geo-replication configuration for disaster recovery
  geo_replication = {
    enabled                     = var.idpay_pgflex_params.geo_replication_enabled
    name                        = "${local.project}-pgflex-replica"
    location                    = "germanywestcentral"
    private_dns_registration_ve = true
  }
  storage_tier = var.idpay_pgflex_params.storage_tier != null ? var.idpay_pgflex_params.storage_tier : null

  tags = module.tag_config.tags_grafana_yes
}

resource "postgresql_role" "idpay_service" {
  for_each = local.idpay_postgres_service_roles

  name                = each.value.role_name
  login               = true
  password_wo         = azurerm_key_vault_secret.idpay_postgres_service_password[each.key].value
  password_wo_version = 1

  create_database = false
  create_role     = false
  replication     = each.key == "kafka_connect"
  superuser       = false

  depends_on = [module.idpay_pgflex]
}

resource "postgresql_schema" "idpay_flyway" {
  for_each = local.idpay_postgres_flyway_schemas

  name     = each.key
  database = local.idpay_postgres_database
  owner    = postgresql_role.idpay_service[each.value].name

  depends_on = [module.idpay_pgflex]
}

resource "postgresql_grant" "idpay_service_database" {
  for_each = local.idpay_postgres_service_roles

  database    = local.idpay_postgres_database
  role        = postgresql_role.idpay_service[each.key].name
  object_type = "database"
  # Flyway V1 initializes each service-owned schema.
  privileges = (
    contains(values(local.idpay_postgres_flyway_schemas), each.key) ||
    each.key == "kafka_connect"
  ) ? ["CONNECT", "CREATE"] : ["CONNECT"]

  depends_on = [module.idpay_pgflex, postgresql_schema.idpay_flyway]
}

resource "postgresql_grant" "idpay_service_schema" {
  for_each = local.idpay_postgres_flyway_schemas

  database    = local.idpay_postgres_database
  role        = postgresql_role.idpay_service[each.value].name
  schema      = postgresql_schema.idpay_flyway[each.key].name
  object_type = "schema"
  privileges  = ["USAGE", "CREATE"]

  depends_on = [postgresql_grant.idpay_service_database]
}

resource "postgresql_grant" "idpay_service_tables" {
  for_each = local.idpay_postgres_flyway_schemas

  database    = local.idpay_postgres_database
  role        = postgresql_role.idpay_service[each.value].name
  schema      = postgresql_schema.idpay_flyway[each.key].name
  object_type = "table"
  privileges  = ["ALL"]

  depends_on = [postgresql_grant.idpay_service_schema]
}

resource "postgresql_grant" "idpay_service_sequences" {
  for_each = local.idpay_postgres_flyway_schemas

  database    = local.idpay_postgres_database
  role        = postgresql_role.idpay_service[each.value].name
  schema      = postgresql_schema.idpay_flyway[each.key].name
  object_type = "sequence"
  privileges  = ["ALL"]

  depends_on = [postgresql_grant.idpay_service_schema]
}

resource "postgresql_grant" "idpay_service_routines" {
  for_each = local.idpay_postgres_flyway_schemas

  database    = local.idpay_postgres_database
  role        = postgresql_role.idpay_service[each.value].name
  schema      = postgresql_schema.idpay_flyway[each.key].name
  object_type = "routine"
  privileges  = ["ALL"]

  depends_on = [postgresql_grant.idpay_service_schema]
}

resource "postgresql_grant" "idpay_kafka_connect_schema" {
  count = var.idpay_pgflex_params.enabled ? 1 : 0

  database    = local.idpay_postgres_database
  role        = postgresql_role.idpay_service["kafka_connect"].name
  schema      = postgresql_schema.idpay_flyway["idpay-pagamenti"].name
  object_type = "schema"
  privileges  = ["USAGE"]

  depends_on = [postgresql_grant.idpay_service_database]
}

resource "postgresql_grant" "idpay_kafka_connect_tables" {
  count = var.idpay_pgflex_params.enabled ? 1 : 0

  database    = local.idpay_postgres_database
  role        = postgresql_role.idpay_service["kafka_connect"].name
  schema      = postgresql_schema.idpay_flyway["idpay-pagamenti"].name
  object_type = "table"
  privileges  = ["SELECT"]

  depends_on = [postgresql_grant.idpay_kafka_connect_schema]
}

resource "postgresql_default_privileges" "idpay_kafka_connect_tables" {
  count = var.idpay_pgflex_params.enabled ? 1 : 0

  database    = local.idpay_postgres_database
  owner       = postgresql_role.idpay_service["payment"].name
  role        = postgresql_role.idpay_service["kafka_connect"].name
  schema      = postgresql_schema.idpay_flyway["idpay-pagamenti"].name
  object_type = "table"
  privileges  = ["SELECT"]

  depends_on = [postgresql_grant.idpay_kafka_connect_schema]
}
