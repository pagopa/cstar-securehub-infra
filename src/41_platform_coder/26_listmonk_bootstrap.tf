# Reuse only the non-credential SES configuration already consumed by Keycloak.
# Do not read Keycloak SMTP credentials or AWS remote state into this module.
data "azurerm_key_vault" "listmonk_ses_configuration" {
  count = var.listmonk_smtp.enabled ? 1 : 0

  name                = "${local.product_nodomain}-idpay-kv"
  resource_group_name = "${local.product_nodomain}-idpay-security-rg"
}

data "azurerm_key_vault_secret" "listmonk_ses_host" {
  count = var.listmonk_smtp.enabled ? 1 : 0

  name         = "aws-pari-ses-mail-host"
  key_vault_id = data.azurerm_key_vault.listmonk_ses_configuration[0].id
}

data "azurerm_key_vault_secret" "listmonk_ses_from" {
  count = var.listmonk_smtp.enabled ? 1 : 0

  name         = "aws-pari-ses-mail-from"
  key_vault_id = data.azurerm_key_vault.listmonk_ses_configuration[0].id
}

locals {
  # Exact Listmonk 6.2.0 settings format. Credentials are added only by psql at runtime.
  listmonk_smtp_servers = var.listmonk_smtp.enabled ? [{
    # The settings API uses this ID to retain the stored password on UI saves.
    uuid            = uuidv5("url", "https://${local.listmonk_ingress_hostname}/smtp/aws-ses")
    enabled         = true
    host            = data.azurerm_key_vault_secret.listmonk_ses_host[0].value
    port            = 465
    auth_protocol   = "login"
    tls_type        = "TLS"
    tls_skip_verify = false
    max_conns       = 1
    idle_timeout    = "15s"
    wait_timeout    = "5s"
    max_msg_retries = 2
    msg_retry_delay = "1s"
    hello_hostname  = ""
    email_headers   = []
    from_addresses  = [data.azurerm_key_vault_secret.listmonk_ses_from[0].value]
  }] : []
}

data "azurerm_key_vault_secret" "listmonk_oidc_client_secret" {
  count = var.listmonk_sso.enabled ? 1 : 0

  name         = var.listmonk_sso.client_secret_name
  key_vault_id = data.azurerm_key_vault.key_vault_core.id
}

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

resource "kubernetes_secret" "listmonk_bootstrap" {
  metadata {
    name      = "listmonk-bootstrap"
    namespace = local.listmonk_namespace
  }

  data = {
    LISTMONK_SMTP_ENABLED   = tostring(var.listmonk_smtp.enabled)
    LISTMONK_SMTP_CONFIG    = jsonencode(local.listmonk_smtp_servers)
    LISTMONK_FROM_EMAIL     = var.listmonk_smtp.enabled ? data.azurerm_key_vault_secret.listmonk_ses_from[0].value : ""
    LISTMONK_MESSAGE_RATE   = tostring(var.listmonk_smtp.message_rate)
    LISTMONK_ADMIN_PASSWORD = azurerm_key_vault_secret.listmonk_admin_password.value
    LISTMONK_OIDC_CONFIG = jsonencode({
      enabled              = var.listmonk_sso.enabled
      provider_url         = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/v2.0"
      provider_name        = "Microsoft Entra ID"
      client_id            = var.listmonk_sso.client_id
      client_secret        = var.listmonk_sso.enabled ? data.azurerm_key_vault_secret.listmonk_oidc_client_secret[0].value : ""
      auto_create_users    = var.listmonk_sso.auto_create_users
      default_user_role_id = var.listmonk_sso.default_user_role_id
      default_list_role_id = null
    })
  }
}

resource "kubernetes_config_map" "listmonk_bootstrap" {
  metadata {
    name      = "listmonk-bootstrap"
    namespace = local.listmonk_namespace
  }

  data = {
    "settings.sql" = file("${path.module}/k8s/listmonk/settings.sql")
  }
}

locals {
  # Other configuration changes already update the Pod spec and trigger a rollout.
  listmonk_bootstrap_checksum = nonsensitive(sha256(jsonencode({
    settings                 = kubernetes_config_map.listmonk_bootstrap.data
    bootstrap                = kubernetes_secret.listmonk_bootstrap.data
    database                 = kubernetes_secret.listmonk_db.data
    smtp_credential_revision = var.listmonk_smtp.credential_revision
  })))
}
