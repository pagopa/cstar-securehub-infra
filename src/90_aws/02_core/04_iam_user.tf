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
            "ses:FromAddress" = "${local.ses_username}@${local.ses_domain}"
          }
        }
      },
    ]
  })
}

resource "aws_iam_access_key" "ses_user" {
  user = local.iam_ses_user
}
