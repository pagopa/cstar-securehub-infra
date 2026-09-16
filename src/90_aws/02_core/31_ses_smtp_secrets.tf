# resource "aws_secretsmanager_secret" "ses_smtp" {
#   name        = "${var.prefix}/${var.env}/ses-smtp"
#   description = "SMTP & IAM creds for Keycloak via Amazon SES"
# }
#
# resource "aws_secretsmanager_secret_version" "ses_smtp" {
#   secret_id = aws_secretsmanager_secret.ses_smtp.id
#   secret_string = jsonencode({
#     host              = local.ses_smtp_host,
#     port              = local.ses_smtp_port,
#     username          = aws_iam_access_key.aws_ses_user.id, # AccessKeyId
#     password          = aws_iam_access_key.aws_ses_user.ses_smtp_password_v4,
#     access_key_id     = aws_iam_access_key.aws_ses_user.id,
#     secret_access_key = aws_iam_access_key.aws_ses_user.secret,
#     from_address      = local.ses_from_address,
#     mail_from_domain  = local.ses_mail_from_dom
#   })
# }

#########################
# Azure Key Vault copy  #
#########################
resource "azurerm_key_vault_secret" "ses_smtp_username" {
  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-ses-mail-smtp-username"
  value        = aws_iam_access_key.aws_ses_user["${local.domain_prefix}bonuselettrodomestici.pagopa.it"].id
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "ses_smtp_password" {
  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-ses-mail-smtp-password"
  value        = aws_iam_access_key.aws_ses_user["${local.domain_prefix}bonuselettrodomestici.pagopa.it"].ses_smtp_password_v4
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "ses_smtp_host" {
  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-ses-mail-host"
  value        = local.ses_smtp_host
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "ses_from_address" {
  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-ses-mail-from"
  value        = local.ses_from_address
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "ses_mail_from_domain" {
  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-ses-mail-from-domain"
  value        = local.ses_mail_from_dom
  tags         = local.tags
}

# --- Raw IAM keys (if SDK usage is needed) ---
resource "azurerm_key_vault_secret" "ses_access_key" {
  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-ses-mail-user-access-key"
  value        = aws_iam_access_key.aws_ses_user["${local.domain_prefix}bonuselettrodomestici.pagopa.it"].id
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "ses_secret_key" {
  key_vault_id = data.azurerm_key_vault.kv_idpay.id
  name         = "aws-ses-mail-user-secret-key"
  value        = aws_iam_access_key.aws_ses_user["${local.domain_prefix}bonuselettrodomestici.pagopa.it"].secret
  tags         = local.tags
}

#----------------------------------------------------------------------------------------------------

resource "aws_secretsmanager_secret" "aws_ses_smtp" {
  for_each = local.ses_domains

  name        = "${var.prefix}/${var.env}/${each.value.domain}/ses-smtp"
  description = "SMTP & IAM creds for ${upper(each.value.domain)} via Amazon SES"
}

resource "aws_secretsmanager_secret_version" "aws_ses_smtp" {
  for_each = local.ses_domains

  secret_id = aws_secretsmanager_secret.aws_ses_smtp[each.key].id
  secret_string = jsonencode({
    host              = local.ses_smtp_host,
    port              = local.ses_smtp_port,
    username          = aws_iam_access_key.aws_ses_user[each.key].id, # AccessKeyId
    password          = aws_iam_access_key.aws_ses_user[each.key].ses_smtp_password_v4,
    access_key_id     = aws_iam_access_key.aws_ses_user[each.key].id,
    secret_access_key = aws_iam_access_key.aws_ses_user[each.key].secret,
    from_address      = "${local.ses_username}@${each.key}",
    mail_from_domain  = aws_ses_domain_mail_from.aws_noreply[each.key].mail_from_domain
  })
}

moved {
  from = aws_secretsmanager_secret.ses_smtp
  to   = aws_secretsmanager_secret.aws_ses_smtp["uat.bonuselettrodomestici.pagopa.it"]
}

moved {
  from = aws_secretsmanager_secret_version.ses_smtp
  to   = aws_secretsmanager_secret_version.aws_ses_smtp["uat.bonuselettrodomestici.pagopa.it"]
}
