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
