resource "azurerm_monitor_scheduled_query_rules_alert" "alerts" {
  for_each = contains(["u", "p"], var.env_short) ? local.final_alerts : tomap({})

  name                = each.value.name
  resource_group_name = local.monitor_rg
  location            = var.location

  description = each.value.description
  enabled     = lookup(try(each.value.enabled_by_env, {}), var.env_short, lookup(each.value, "enabled", true))
  severity    = lookup(try(each.value.severity_by_env, {}), var.env_short, each.value.severity)

  frequency   = each.value.frequency
  time_window = each.value.time_window

  data_source_id = each.value.data_source_id
  query          = each.value.query

  trigger {
    operator  = each.value.trigger.operator
    threshold = each.value.trigger.threshold
  }

  action {
    action_group  = lookup(each.value, "action_groups", local.alert_action_group)
    email_subject = each.value.email_subject
  }
}
