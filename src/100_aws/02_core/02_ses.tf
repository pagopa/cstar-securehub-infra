module "ses" {
  source = "git::https://github.com/pagopa/terraform-aws-ses.git?ref=d9006a0e756b8ae963abc29624e57bc21001c345" # v1.3.1

  domain         = local.ses_domain
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
