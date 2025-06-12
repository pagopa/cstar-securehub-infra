# Iam user created in eng-aws-auth with name: "cstar-ENV-ses-user"

resource "aws_iam_user_policy" "ses_user_policy" {
  name = "ses-user-policy"
  user = local.iam_ses_user

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail",
        ]
        Resource = module.ses.ses_domain_identity_arn
        Condition = {
          StringEquals = {
            "ses:FromAddress" = "noreply@${local.ses_domain}"
          }
        }
      },
    ]
  })
}

resource "aws_iam_access_key" "ses_user" {
  user = local.iam_ses_user
}

# ACCESS KEY & SECRET KEY in IDPAY KV
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
}
