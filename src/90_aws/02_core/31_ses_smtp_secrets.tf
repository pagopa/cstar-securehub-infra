resource "aws_secretsmanager_secret" "aws_ses_smtp" {
  for_each = local.ses_domains

  name        = "${var.prefix}/${var.env}/${each.value.domain}/ses-smtp"
  description = "SMTP & IAM creds for ${upper(each.value.domain)} via Amazon SES"
}

resource "aws_secretsmanager_secret_version" "aws_ses_smtp" {
  for_each = local.ses_active_keys

  secret_id = aws_secretsmanager_secret.aws_ses_smtp[each.key].id
  secret_string = jsonencode({
    host              = local.ses_smtp_host,
    port              = local.ses_smtp_port,
    username          = local.ses_active_keys[each.key].id, # AccessKeyId
    password          = local.ses_active_keys[each.key].ses_smtp_password_v4,
    access_key_id     = local.ses_active_keys[each.key].id,
    secret_access_key = local.ses_active_keys[each.key].secret,
    from_address      = "${local.ses_username}@${each.key}",
    mail_from_domain  = aws_ses_domain_mail_from.aws_noreply[each.key].mail_from_domain
  })
}
