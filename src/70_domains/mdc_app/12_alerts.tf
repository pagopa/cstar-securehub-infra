# Action Groups
# Creates one Action Group per alert to support different email addresses
resource "azurerm_monitor_action_group" "alerts" {
  for_each = local.final_alerts

  name                = "${each.value.name}-ag"
  resource_group_name = local.monitor_rg
  short_name          = "ag-${var.env_short}"

  email_receiver {
    name                    = "team-email"
    email_address           = each.value.email_address
    use_common_alert_schema = true
  }

  tags = local.tags
}

# Scheduled Query Rules
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "alerts" {
  for_each = local.final_alerts

  name                 = each.value.name
  resource_group_name  = local.monitor_rg
  location             = var.location
  description          = each.value.description
  enabled              = each.value.enabled
  evaluation_frequency = each.value.evaluation_frequency
  window_duration      = each.value.window_duration
  scopes               = [data.azurerm_log_analytics_workspace.domain_log_analytics.id]
  severity             = each.value.severity

  criteria {
    query                   = each.value.query
    time_aggregation_method = each.value.time_aggregation_method
    threshold               = each.value.threshold
    operator                = each.value.operator

    failing_periods {
      minimum_failing_periods_to_trigger_alert = each.value.minimum_failing_periods
      number_of_evaluation_periods             = each.value.number_of_evaluation_periods
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.alerts[each.key].id]
    custom_properties = {
      "Email.Subject" = each.value.description
    }
  }

  tags = local.tags
}
