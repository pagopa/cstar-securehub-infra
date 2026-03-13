resource "azurerm_monitor_scheduled_query_rules_alert" "alerts" {
  for_each = var.srtp_alerts_enabled ? local.final_alerts : tomap({})

  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = var.location

  description = each.value.description
  enabled     = lookup(each.value, "enabled", true)
  severity    = each.value.severity

  frequency   = each.value.frequency
  time_window = each.value.time_window

  data_source_id = each.value.data_source_id
  query          = each.value.query

  trigger {
    operator  = each.value.trigger.operator
    threshold = each.value.trigger.threshold
  }

  action {
    action_group  = lookup(each.value, "action_groups", compact([try(azurerm_monitor_action_group.email[0].id, null)]))
    email_subject = each.value.email_subject
  }

  tags = module.tag_config.tags
}
