resource "random_password" "listmonk_admin" {
  count   = local.listmonk_enabled ? 1 : 0
  length  = 32
  special = false
}

resource "azurerm_key_vault_secret" "listmonk_admin_password" {
  count        = local.listmonk_enabled ? 1 : 0
  name         = "listmonk-admin-password"
  value        = random_password.listmonk_admin[0].result
  key_vault_id = data.azurerm_key_vault.key_vault_core.id
  content_type = "text/plain"

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "listmonk_admin_username" {
  count        = local.listmonk_enabled ? 1 : 0
  name         = "listmonk-admin-username"
  value        = "admin"
  key_vault_id = data.azurerm_key_vault.key_vault_core.id
  content_type = "text/plain"

  tags = module.tag_config.tags
}

resource "kubernetes_secret" "listmonk_bootstrap" {
  count = local.listmonk_enabled ? 1 : 0
  metadata {
    name      = "listmonk-bootstrap"
    namespace = local.listmonk_namespace
  }

  data = {
    LISTMONK_ADMIN_PASSWORD = azurerm_key_vault_secret.listmonk_admin_password[0].value
  }
}
