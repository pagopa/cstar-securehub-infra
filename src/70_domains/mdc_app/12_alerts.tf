# Action Groups
# Creates one Action Group per alert, sending to the JSM Azure integration
resource "azurerm_monitor_action_group" "alerts" {
  count = contains(["p", "u"], var.env_short) ? 1 : 0

  name                = "${local.project}-alerts-ag-${var.env_short}"
  resource_group_name = local.monitor_rg
  short_name          = "alerts-ag-${var.env_short}"
  enabled             = true

  webhook_receiver {
    name                    = "jsm-azure"
    service_uri             = local.jsm_webhook_uri
    use_common_alert_schema = true
  }

  dynamic "email_receiver" {
    for_each = local.alert_email_slack_addresses
    content {
      name                    = "email-slack-${var.env_short}"
      email_address           = email_receiver.value
      use_common_alert_schema = false
    }
  }

  tags = local.tags
}

# Scheduled Query Rules
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "alerts" {
  for_each = contains(["p", "u"], var.env_short) ? local.final_alerts : {}

  name                = each.value.name
  display_name        = each.value.name
  description         = each.value.description
  resource_group_name = local.monitor_rg
  location            = var.location
  enabled             = each.value.enabled
  severity            = each.value.severity

  evaluation_frequency = each.value.evaluation_frequency
  window_duration      = each.value.window_duration
  scopes               = [data.azurerm_log_analytics_workspace.domain_log_analytics.id]

  auto_mitigation_enabled = false

  criteria {
    query                   = each.value.query
    time_aggregation_method = "Count"
    operator                = each.value.operator
    threshold               = each.value.threshold

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.alerts[0].id]

    custom_properties = {
      environment = upper(var.env)
    }
  }

  tags = local.tags
}
