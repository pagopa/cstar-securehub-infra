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


# Create PostgreSQL Flexible Server instance for Keycloak
module "keycloak_pgflex" {
  source = "./.terraform/modules/__v4__/IDH/postgres_flexible_server"

  # Basic server configuration
  name                = "${local.project}-keycloak-pgflex"
  location            = data.azurerm_resource_group.platform_data.location
  resource_group_name = data.azurerm_resource_group.platform_data.name

  # Resource tier and environment settings
  idh_resource_tier = var.keycloak_pgflex_params.idh_resource_tier
  product_name      = var.prefix
  env               = var.env

  # Network configuration
  delegated_subnet_id = data.azurerm_subnet.platform_subnet.id
  private_dns_zone_id = data.azurerm_private_dns_zone.postgres_flexible_privatelink.id

  # Authentication configuration
  administrator_login    = azurerm_key_vault_secret.keycloak_db_admin_user.value
  administrator_password = azurerm_key_vault_secret.keycloak_db_admin_password.value

  # Monitoring and performance settings
  diagnostic_settings_enabled = var.keycloak_pgflex_params.pgres_flex_diagnostic_settings_enabled
  log_analytics_workspace_id  = data.azurerm_log_analytics_workspace.logs_workspace.id
  private_dns_registration    = false
  pg_bouncer_enabled          = var.keycloak_pgflex_params.pgres_flex_pgbouncer_enabled
  zone                        = var.keycloak_pgflex_params.zone

  # Geo-replication configuration for disaster recovery
  geo_replication = {
    enabled                     = var.keycloak_pgflex_params.geo_replication_enabled
    name                        = "${local.project}-keycloak-pgflex-replica"
    subnet_id                   = data.azurerm_subnet.platform_subnet.id
    location                    = "germanywestcentral"
    private_dns_registration_ve = true
  }

  tags = module.tag_config.tags_grafana_yes
}

resource "azurerm_postgresql_flexible_server_database" "keycloak_db" {
  name      = local.keycloak_db_name
  server_id = module.keycloak_pgflex.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
