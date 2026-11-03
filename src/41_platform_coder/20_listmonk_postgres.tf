resource "azurerm_postgresql_flexible_server_database" "listmonk_db" {
  name      = local.listmonk_db_name
  server_id = module.keycloak_pgflex.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "random_password" "listmonk_db" {
  length           = 32
  special          = true
  override_special = "-"
  min_special      = 1
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
}

resource "azurerm_key_vault_secret" "listmonk_db_user" {
  name         = "listmonk-db-user"
  value        = "listmonk"
  key_vault_id = data.azurerm_key_vault.key_vault_core.id
  content_type = "text/plain"

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "listmonk_db_password" {
  name         = "listmonk-db-password"
  value        = random_password.listmonk_db.result
  key_vault_id = data.azurerm_key_vault.key_vault_core.id
  content_type = "text/plain"

  tags = module.tag_config.tags
}

resource "postgresql_role" "listmonk" {
  name                = azurerm_key_vault_secret.listmonk_db_user.value
  login               = true
  password_wo         = azurerm_key_vault_secret.listmonk_db_password.value
  password_wo_version = azurerm_key_vault_secret.listmonk_db_password.version

  superuser                 = false
  create_database           = false
  create_role               = false
  replication               = false
  bypass_row_level_security = false
  inherit                   = false
  roles                     = []
  search_path               = ["public"]
}

# Restrict PUBLIC only in the new database; existing databases are not modified.
resource "postgresql_grant" "listmonk_public_database" {
  database    = azurerm_postgresql_flexible_server_database.listmonk_db.name
  role        = "public"
  object_type = "database"
  privileges  = []
}

resource "postgresql_grant" "listmonk_public_schema" {
  database    = azurerm_postgresql_flexible_server_database.listmonk_db.name
  role        = "public"
  schema      = "public"
  object_type = "schema"
  privileges  = []
}

resource "postgresql_grant" "listmonk_database" {
  database    = azurerm_postgresql_flexible_server_database.listmonk_db.name
  role        = postgresql_role.listmonk.name
  object_type = "database"
  privileges  = ["CONNECT", "TEMPORARY"]

  depends_on = [postgresql_grant.listmonk_public_database]
}

resource "postgresql_grant" "listmonk_schema" {
  database    = azurerm_postgresql_flexible_server_database.listmonk_db.name
  role        = postgresql_role.listmonk.name
  schema      = "public"
  object_type = "schema"
  privileges  = ["USAGE", "CREATE"]

  depends_on = [postgresql_grant.listmonk_public_schema]
}

# Install as the server administrator, not as the application role.
resource "postgresql_extension" "listmonk_pgcrypto" {
  name     = "pgcrypto"
  database = azurerm_postgresql_flexible_server_database.listmonk_db.name
  schema   = "public"
}
