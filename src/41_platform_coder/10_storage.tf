

resource "azurerm_resource_group" "postgres_dbs" {
  name     = "${local.program}-postgres-dbs-rg"
  location = var.location

  tags = var.tags
}

# Postgres Flexible Server subnet
#
# Public Flexible
#

# https://docs.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-compare-single-server-flexible-server
module "postgres_flexible_server_public" {

  # source = "./.terraform/modules/__v4__/azure_devops_agent"
  count = var.pgflex_public_config.enabled ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//postgres_flexible_server"

  name                = "${local.program}-public-pgflex"
  location            = azurerm_resource_group.postgres_dbs.location
  resource_group_name = azurerm_resource_group.postgres_dbs.name

  administrator_login    = data.azurerm_key_vault_secret.pgres_flex_admin_login.value
  administrator_password = data.azurerm_key_vault_secret.pgres_flex_admin_pwd.value

  sku_name   = "B_Standard_B1ms"
  db_version = "13"
  # Possible values are 32768, 65536, 131072, 262144, 524288, 1048576,
  # 2097152, 4194304, 8388608, 16777216, and 33554432.
  storage_mb                   = 32768
  zone                         = 1
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  high_availability_enabled = false
  private_endpoint_enabled  = false
  pgbouncer_enabled         = false

  tags = var.tags

  custom_metric_alerts = var.pgflex_public_metric_alerts
  alerts_enabled       = true

  diagnostic_settings_enabled               = true
  #log_analytics_workspace_id                = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  # diagnostic_setting_destination_storage_id = data.azurerm_storage_account.security_monitoring_storage.id

}