resource "random_password" "listmonk_admin" {
  length  = 32
  special = false
}

resource "azurerm_key_vault_secret" "listmonk_admin_password" {
  name         = "listmonk-admin-password"
  value        = random_password.listmonk_admin.result
  key_vault_id = data.azurerm_key_vault.key_vault_core.id
  content_type = "text/plain"

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "listmonk_admin_username" {
  name         = "listmonk-admin-username"
  value        = "admin"
  key_vault_id = data.azurerm_key_vault.key_vault_core.id
  content_type = "text/plain"

  tags = module.tag_config.tags
}

resource "kubernetes_secret" "listmonk_bootstrap" {
  metadata {
    name      = "listmonk-bootstrap"
    namespace = local.listmonk_namespace
  }

  data = {
    LISTMONK_ADMIN_PASSWORD = azurerm_key_vault_secret.listmonk_admin_password.value
  }
}
