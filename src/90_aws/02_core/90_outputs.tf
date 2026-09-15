output "aws_ses_user_access_keys" {
  description = "Map of SES domain -> IAM access key id/secret for the per-domain SES user"
  value = {
    for domain, key in aws_iam_access_key.aws_ses_user : domain => {
      id                       = key.id
      secret                   = key.secret
      ses_smtp_password_v4     = key.ses_smtp_password_v4
      aws_ses_domain_mail_from = aws_ses_domain_mail_from.aws_noreply[domain].mail_from_domain
    }
  }
  sensitive = true
}
