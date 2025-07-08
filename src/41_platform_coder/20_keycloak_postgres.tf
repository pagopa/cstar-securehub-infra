#
# 🔒 KV
#
resource "azurerm_key_vault_secret" "keycloak_db_admin_user" {
  name         = "keycloak-db-admin-user"
  value        = "keycloak"
  key_vault_id = data.azurerm_key_vault.key_vault_core.id # Assumiamo che l'ID del Key Vault sia passato come variabile

  content_type = "text/plain"

  tags = var.tags
}

resource "random_password" "keycloak_db_admin_password" {
  length      = 12
  special     = true
  min_special = 1
  # Limitiamo i caratteri speciali al solo "-"
  override_special = "-"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
}

resource "azurerm_key_vault_secret" "keycloak_db_admin_password" {
  name         = "keycloak-db-admin-password"
  value        = random_password.keycloak_db_admin_password.result
  key_vault_id = data.azurerm_key_vault.key_vault_core.id

  content_type = "text/plain"

  tags = var.tags
}


#
# Postgres Flexible Server
#
module "keycloak_pgflex" {
  source = "./.terraform/modules/__v4__/postgres_flexible_server"

  name                     = "${local.project}-keycloak-pgflex"
  location                 = data.azurerm_resource_group.platform_data.location
  resource_group_name      = data.azurerm_resource_group.platform_data.name
  private_endpoint_enabled = true

  # Network
  delegated_subnet_id = data.azurerm_subnet.platform_subnet.id
  private_dns_zone_id = data.azurerm_private_dns_zone.postgres_flexible_privatelink.id

  high_availability_enabled   = var.keycloak_pgflex_params.pgres_flex_ha_enabled
  standby_availability_zone   = var.env_short != "d" ? var.keycloak_pgflex_params.standby_zone : null
  pgbouncer_enabled           = var.keycloak_pgflex_params.pgres_flex_pgbouncer_enabled
  diagnostic_settings_enabled = var.keycloak_pgflex_params.pgres_flex_diagnostic_settings_enabled
  administrator_login         = azurerm_key_vault_secret.keycloak_db_admin_user.value
  administrator_password      = azurerm_key_vault_secret.keycloak_db_admin_password.value

  sku_name                     = var.keycloak_pgflex_params.sku_name
  db_version                   = var.keycloak_pgflex_params.db_version
  storage_mb                   = var.keycloak_pgflex_params.storage_mb
  zone                         = var.env_short == "d" ? 2 : var.keycloak_pgflex_params.zone
  backup_retention_days        = var.keycloak_pgflex_params.backup_retention_days
  geo_redundant_backup_enabled = var.keycloak_pgflex_params.geo_redundant_backup_enabled
  create_mode                  = var.keycloak_pgflex_params.create_mode

  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs_workspace.id

  tags = merge(var.tags, {
    "domain"  = "platform",
    "grafana" = "yes"
  })
}

resource "azurerm_postgresql_flexible_server_database" "keycloak_db" {
  name      = local.keycloak_db_name
  server_id = module.keycloak_pgflex.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
