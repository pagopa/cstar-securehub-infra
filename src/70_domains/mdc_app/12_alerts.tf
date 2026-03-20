# Action Groups
# Creates one Action Group per alert to support different email addresses
resource "azurerm_monitor_action_group" "alerts" {
  for_each = var.env_short == "p" ? local.final_alerts : {}

  name                = "${each.value.name}-ag"
  resource_group_name = local.monitor_rg
  short_name          = "ag-${var.env_short}"

  dynamic "email_receiver" {
    for_each = each.value.email_addresses

    content {
      name                    = "email-${email_receiver.key}"
      email_address           = email_receiver.value
    }
  }

  tags = local.tags
}

# Scheduled Query Rules
resource "azurerm_monitor_scheduled_query_rules_alert" "alerts" {
  for_each = var.env_short == "p" ? local.final_alerts : {}

  name                = each.value.name
  resource_group_name = local.monitor_rg
  location            = var.location
  enabled             = each.value.enabled
  frequency           = each.value.evaluation_frequency
  time_window         = each.value.window_duration
  data_source_id      = data.azurerm_log_analytics_workspace.domain_log_analytics.id
  severity            = each.value.severity

  query               = each.value.query

  trigger {
    operator  = each.value.operator
    threshold = each.value.threshold
  }

  action {
    action_group  = [azurerm_monitor_action_group.alerts[each.key].id]
    email_subject = each.value.email_subject
  }

  tags = local.tags
}
