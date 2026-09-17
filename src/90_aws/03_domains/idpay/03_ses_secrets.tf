# PARI SES SECRETS
# SES USERNAME
resource "azurerm_key_vault_secret" "ses_smtp_username" {
  for_each = local.ses_domains

  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-${each.value.secret_domain}ses-mail-smtp-username"
  value        = data.terraform_remote_state.core.outputs.aws_ses_user_access_keys[each.key].id
  tags         = local.tags
}


# --- Raw IAM keys (if SDK usage is needed) ---
resource "azurerm_key_vault_secret" "ses_access_key" {
  for_each = local.ses_domains

  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-${each.value.secret_domain}ses-mail-user-access-key"
  value        = data.terraform_remote_state.core.outputs.aws_ses_user_access_keys[each.key].id
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "ses_secret_key" {
  for_each = local.ses_domains

  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-${each.value.secret_domain}ses-mail-user-secret-key"
  value        = data.terraform_remote_state.core.outputs.aws_ses_user_access_keys[each.key].secret
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "ses_smtp_password" {
  for_each = local.ses_domains

  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-${each.value.secret_domain}ses-mail-smtp-password"
  value        = data.terraform_remote_state.core.outputs.aws_ses_user_access_keys[each.key].ses_smtp_password_v4
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "ses_smtp_host" {
  for_each = local.ses_domains

  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-${each.value.secret_domain}ses-mail-host"
  value        = local.ses_smtp_host
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "ses_from_address" {
  for_each = local.ses_domains

  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-${each.value.secret_domain}ses-mail-from"
  value        = "${local.ses_username}@${each.key}"
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "ses_mail_from_domain" {
  for_each = local.ses_domains

  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-${each.value.secret_domain}ses-mail-from-domain"
  value        = data.terraform_remote_state.core.outputs.aws_ses_user_access_keys[each.key].aws_ses_domain_mail_from
  tags         = local.tags
}
