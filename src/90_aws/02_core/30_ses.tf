# module "ses" {
#   source = "git::https://github.com/pagopa/terraform-aws-ses.git?ref=d9006a0e756b8ae963abc29624e57bc21001c345" # v1.3.1
#
#   domain         = local.ses_domain
#   user_name      = null
#   ses_group_name = null
#
#   alarms = {
#     actions                    = [aws_sns_topic.alarms.arn]
#     daily_send_quota_threshold = 100
#     daily_send_quota_period    = 60 * 60 * 24 # 1 day
#
#     reputation_complaint_rate_threshold = 0.8
#     reputation_complaint_rate_period    = 60 * 60 # 1 hour.
#
#     reputation_bounce_rate_threshold = 0.1
#     reputation_bounce_rate_period    = 5 * 60 # 5min
#   }
# }
#
# resource "aws_ses_domain_mail_from" "noreply" {
#   domain           = local.ses_domain
#   mail_from_domain = "${local.ses_username}.${local.ses_domain}"
#
#   depends_on = [
#     module.aws_ses
#   ]
# }

#----------------------------------------------------------------------------------------------------
module "aws_ses" {
  source   = "git::https://github.com/pagopa/terraform-aws-ses.git?ref=d9006a0e756b8ae963abc29624e57bc21001c345" # v1.3.1
  for_each = local.ses_domains

  domain         = each.key
  user_name      = null
  ses_group_name = null

  alarms = {
    actions                    = [aws_sns_topic.alarms.arn]
    daily_send_quota_threshold = 100
    daily_send_quota_period    = 60 * 60 * 24 # 1 day

    reputation_complaint_rate_threshold = 0.8
    reputation_complaint_rate_period    = 60 * 60 # 1 hour.

    reputation_bounce_rate_threshold = 0.1
    reputation_bounce_rate_period    = 5 * 60 # 5min
  }
}

resource "aws_ses_domain_mail_from" "aws_noreply" {
  for_each = local.ses_domains

  domain           = each.key
  mail_from_domain = "${local.ses_username}.${each.key}"

  depends_on = [
    module.aws_ses
  ]
}

#----------------------------------------------------------------------------------------------------

moved {
  from = module.ses
  to   = module.aws_ses["uat.bonuselettrodomestici.pagopa.it"]
}

moved {
  from = aws_ses_domain_mail_from.noreply
  to   = aws_ses_domain_mail_from.aws_noreply["uat.bonuselettrodomestici.pagopa.it"]
}
