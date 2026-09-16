# # Iam user created in eng-aws-auth with name: "cstar-ENV-ses-user"
#
# resource "aws_iam_user_policy" "ses_user_policy" {
#   name = "ses-user-policy"
#   user = local.iam_ses_user
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "ses:SendEmail",
#           "ses:SendRawEmail",
#         ]
#         Resource = module.ses.ses_domain_identity_arn
#         Condition = {
#           StringEquals = {
#             "ses:FromAddress" = "${local.ses_username}@${local.ses_domain}"
#           }
#         }
#       },
#     ]
#   })
# }
#
# resource "aws_iam_access_key" "ses_user" {
#   user = local.iam_ses_user
# }

#----------------------------------------------------------------------------------------------------

resource "aws_iam_user_policy" "aws_ses_user_policy" {
  for_each = local.ses_domains

  name = "ses-user-policy"
  user = each.value.iam_user

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail",
        ]
        Resource = module.aws_ses[each.key].ses_domain_identity_arn
        Condition = {
          StringEquals = {
            "ses:FromAddress" = "${local.ses_username}@${each.key}"
          }
        }
      },
    ]
  })
}

resource "aws_iam_access_key" "aws_ses_user" {
  for_each = local.ses_domains

  user = each.value.iam_user
}

moved {
  from = aws_iam_user_policy.ses_user_policy
  to   = aws_iam_user_policy.aws_ses_user_policy["uat.bonuselettrodomestici.pagopa.it"]
}

moved {
  from = aws_iam_access_key.ses_user
  to   = aws_iam_access_key.aws_ses_user["uat.bonuselettrodomestici.pagopa.it"]
}
