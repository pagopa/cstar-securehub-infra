
locals {
  ses_smtp_host = "email-smtp.${var.aws_region}.amazonaws.com"
  ses_smtp_port = 587
}

# Random suffix to keep the secret name idempotent but unique
resource "random_id" "ses_secret_suffix" {
  byte_length = 4
}

resource "aws_secretsmanager_secret" "ses_smtp" {
  name        = "${var.prefix}/${var.env}/ses-smtp-${random_id.ses_secret_suffix.hex}"
  description = "SMTP credentials for Keycloak via Amazon SES"
  tags        = local.tags
}

resource "aws_secretsmanager_secret_version" "ses_smtp" {
  secret_id     = aws_secretsmanager_secret.ses_smtp.id
  secret_string = jsonencode({
    host     = local.ses_smtp_host,
    port     = local.ses_smtp_port,
    username = aws_iam_access_key.ses_user.id,
    password = aws_iam_access_key.ses_user.ses_smtp_password_v4
  })
}

# -----------------------------
# Azure Key Vault replicas
# -----------------------------
resource "azurerm_key_vault_secret" "ses_username" {
  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-${var.prefix}-ses-username"
  value        = "${local.ses_username}@${local.ses_domain}"
  tags         = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "ses_smtp_password" {
  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-${var.prefix}-ses-smtp-password"
  value        = aws_iam_access_key.ses_user.ses_smtp_password_v4
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "ses_smtp_host" {
  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-${var.prefix}-ses-host"
  value        = local.ses_smtp_host
  tags         = local.tags
}

#-----------------------------------------
# Access Key for SES User
#-----------------------------------------
resource "azurerm_key_vault_secret" "ses_access_key" {
  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-${var.prefix}-ses-user-access-key"
  value        = aws_iam_access_key.ses_user.id
  tags         = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "ses_secret_key" {
  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-${var.prefix}-ses-user-secret-key"
  value        = aws_iam_access_key.ses_user.secret
  tags         = module.tag_config.tags
}


