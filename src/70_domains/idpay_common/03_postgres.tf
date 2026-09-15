#
# 🔒 KV
#
locals {
  idpay_postgres_database = "idpay-database"
  idpay_postgres_flyway_schemas = var.idpay_pgflex_params.enabled ? toset([
    "idpay-pagamenti",
    "idpay-rimborsi",
  ]) : toset([])
}

resource "azurerm_key_vault_secret" "idpay_postgres_admin_user" {
  count        = var.idpay_pgflex_params.enabled ? 1 : 0
  name         = "idpay-postgres-admin-user"
  value        = "idpaydbadmin"
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  content_type = "text/plain"

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "idpay_postgres_app_user" {
  count        = var.idpay_pgflex_params.enabled ? 1 : 0
  name         = "idpay-postgres-app-user"
  value        = "idpaydbapp"
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

resource "random_password" "idpay_postgres_app_password" {
  count       = var.idpay_pgflex_params.enabled ? 1 : 0
  length      = 32
  special     = true
  min_special = 1
  # Limitiamo i caratteri speciali al solo "-"
  override_special = "-"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
}

resource "azurerm_key_vault_secret" "idpay_postgres_app_password" {
  count        = var.idpay_pgflex_params.enabled ? 1 : 0
  name         = "idpay-postgres-app-password"
  value        = random_password.idpay_postgres_app_password[0].result
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
  value        = "jdbc:postgresql://${module.idpay_pgflex[0].fqdn}:5432/${local.idpay_postgres_database}"
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  content_type = "text/plain"

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "idpay_postgres_connection_string_r2dbc" {
  count        = var.idpay_pgflex_params.enabled ? 1 : 0
  name         = "idpay-postgres-connection-string-r2dbc"
  value        = "r2dbc:postgresql://${module.idpay_pgflex[0].fqdn}:5432/${local.idpay_postgres_database}"
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
  private_dns_registration    = false
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

resource "postgresql_role" "idpay_app" {
  count = var.idpay_pgflex_params.enabled ? 1 : 0

  name     = azurerm_key_vault_secret.idpay_postgres_app_user[0].value
  login    = true
  password = azurerm_key_vault_secret.idpay_postgres_app_password[0].value

  depends_on = [module.idpay_pgflex]
}

resource "postgresql_grant" "idpay_app_database" {
  count = var.idpay_pgflex_params.enabled ? 1 : 0

  database    = local.idpay_postgres_database
  role        = postgresql_role.idpay_app[0].name
  object_type = "database"
  privileges  = ["CONNECT", "CREATE"]

  depends_on = [module.idpay_pgflex]
}

resource "postgresql_grant" "idpay_app_schema" {
  for_each = local.idpay_postgres_flyway_schemas

  database    = local.idpay_postgres_database
  role        = postgresql_role.idpay_app[0].name
  schema      = each.value
  object_type = "schema"
  privileges  = ["ALL"]

  depends_on = [postgresql_grant.idpay_app_database]
}

resource "postgresql_grant" "idpay_app_tables" {
  for_each = local.idpay_postgres_flyway_schemas

  database    = local.idpay_postgres_database
  role        = postgresql_role.idpay_app[0].name
  schema      = each.value
  object_type = "table"
  privileges  = ["ALL"]

  depends_on = [postgresql_grant.idpay_app_schema]
}

resource "postgresql_grant" "idpay_app_sequences" {
  for_each = local.idpay_postgres_flyway_schemas

  database    = local.idpay_postgres_database
  role        = postgresql_role.idpay_app[0].name
  schema      = each.value
  object_type = "sequence"
  privileges  = ["ALL"]

  depends_on = [postgresql_grant.idpay_app_schema]
}

resource "postgresql_grant" "idpay_app_routines" {
  for_each = local.idpay_postgres_flyway_schemas

  database    = local.idpay_postgres_database
  role        = postgresql_role.idpay_app[0].name
  schema      = each.value
  object_type = "routine"
  privileges  = ["ALL"]

  depends_on = [postgresql_grant.idpay_app_schema]
}
