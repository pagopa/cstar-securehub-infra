resource "aws_sns_topic" "alarms" {
  name         = "${local.product}-alarms"
  display_name = "${local.product}-alarms"
}

resource "aws_sns_topic_subscription" "alarms_email" {
  endpoint = data.azurerm_key_vault_secret.slack_mail_alarm.value

  endpoint_auto_confirms = true
  protocol               = "email"
  topic_arn              = aws_sns_topic.alarms.arn
}
