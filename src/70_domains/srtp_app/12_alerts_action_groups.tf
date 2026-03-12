# Action Group for Email
resource "azurerm_monitor_action_group" "email" {
  count               = var.srtp_alerts_enabled ? 1 : 0
  name                = "${local.project}-email-ag"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  short_name          = "srtp-email"
  enabled             = true

  email_receiver {
    name                    = "srtp-alerts-email"
    email_address           = "rtp-alerts@pagopa.it"
    use_common_alert_schema = true
  }

  tags = module.tag_config.tags
}

# Action Group for Slack (Email-to-Slack pattern)
resource "azurerm_monitor_action_group" "slack" {
  count               = var.srtp_alerts_enabled ? 1 : 0
  name                = "${local.project}-slack-ag"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  short_name          = "rtp-slack"
  enabled             = true

  email_receiver {
    name                    = "rtp-slack-email"
    email_address           = data.azurerm_key_vault_secret.slack_webhook_email[0].value
    use_common_alert_schema = true
  }

  tags = module.tag_config.tags
}
