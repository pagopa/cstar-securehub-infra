locals {
  pari_smtp = {
    host         = data.azurerm_key_vault_secret.pari_ses_smtp_host.value
    username     = data.azurerm_key_vault_secret.pari_ses_smtp_username.value
    password     = data.azurerm_key_vault_secret.pari_ses_smtp_password.value
    from_address = data.azurerm_key_vault_secret.pari_ses_from_address.value
    port         = local.ses_smtp_port
    ssl          = true
  }

  listmonk_smtp_from_name = "Comunicazioni PARI"
}

resource "kubernetes_secret_v1" "listmonk_smtp" {
  count = var.listmonk_smtp_enabled ? 1 : 0

  metadata {
    name      = "listmonk-smtp"
    namespace = "listmonk"
  }

  data_wo = {
    SMTP_HOST         = local.pari_smtp.host
    SMTP_USERNAME     = local.pari_smtp.username
    SMTP_PASSWORD     = local.pari_smtp.password
    SMTP_FROM_ADDRESS = local.pari_smtp.from_address
    SMTP_FROM_NAME    = local.listmonk_smtp_from_name
    SMTP_PORT         = tostring(local.pari_smtp.port)
    SMTP_TLS_TYPE     = local.pari_smtp.ssl ? "TLS" : "none"
  }

  # Trigger a write on Key Vault rotation without hashing credential values into state.
  data_wo_revision = 1 + parseint(substr(sha256(jsonencode([
    data.azurerm_key_vault_secret.pari_ses_smtp_host.version,
    data.azurerm_key_vault_secret.pari_ses_smtp_username.version,
    data.azurerm_key_vault_secret.pari_ses_smtp_password.version,
    data.azurerm_key_vault_secret.pari_ses_from_address.version,
    local.listmonk_smtp_from_name,
    local.pari_smtp.port,
    local.pari_smtp.ssl,
  ])), 0, 12), 16)
}
