#
# 🔒 KV
#
resource "azurerm_key_vault_secret" "idpay_db_admin_user" {
  name         = "idpay-db-admin-user"
  value        = "idpaydbadmin"
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  content_type = "text/plain"

  tags = module.tag_config.tags
}

resource "random_password" "idpay_db_admin_password" {
  length      = 20
  special     = true
  min_special = 1
  # Limitiamo i caratteri speciali al solo "-"
  override_special = "-"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
}

resource "azurerm_key_vault_secret" "idpay_db_admin_password" {
  name         = "idpay-db-admin-password"
  value        = random_password.idpay_db_admin_password.result
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  content_type = "text/plain"

  tags = module.tag_config.tags
}

module "idpay_pgflex" {
  source = "./.terraform/modules/__v4__/IDH/postgres_flexible_server"

  # Basic server configuration
  name                = "${local.project}-pgflex"
  location            = data.azurerm_resource_group.idpay_data_rg.location
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name

  # Resource tier and environment settings
  idh_resource_tier = var.idpay_pgflex_params.idh_resource_tier
  product_name      = var.prefix
  env               = var.env

  # Network configuration
  embedded_subnet = {
    enabled      = true
    vnet_name    = data.azurerm_virtual_network.vnet_spoke_data.name
    vnet_rg_name = data.azurerm_virtual_network.vnet_spoke_data.resource_group_name
  }
  private_dns_zone_id = data.azurerm_private_dns_zone.postgres_flexible_privatelink.id

  # Authentication configuration
  administrator_login    = azurerm_key_vault_secret.idpay_db_admin_user.value
  administrator_password = azurerm_key_vault_secret.idpay_db_admin_password.value

  # Monitoring and performance settings
  diagnostic_settings_enabled = var.idpay_pgflex_params.pgres_flex_diagnostic_settings_enabled
  log_analytics_workspace_id  = data.azurerm_log_analytics_workspace.domain_log_analytics.id
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
