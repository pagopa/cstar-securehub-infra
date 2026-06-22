resource "azurerm_monitor_scheduled_query_rules_alert_v2" "alerts" {
  for_each = contains(["u", "p"], var.env_short) ? local.final_alerts : tomap({})

  name                = each.value.name
  resource_group_name = local.monitor_rg
  location            = var.location

  scopes = [each.value.scopes]

  description = each.value.description
  enabled     = lookup(try(each.value.enabled_by_env, {}), var.env_short, lookup(each.value, "enabled", true))
  severity    = lookup(try(each.value.severity_by_env, {}), var.env_short, each.value.severity)

  evaluation_frequency = each.value.evaluation_frequency == 1440 ? "P1D" : "PT${each.value.evaluation_frequency}M"
  window_duration      = each.value.window_duration == 1440 ? "P1D" : "PT${each.value.window_duration}M"

  criteria {
    query                   = each.value.query
    time_aggregation_method = "Count"
    operator                = each.value.criteria.operator
    threshold               = each.value.criteria.threshold
  }

  action {
    action_groups = lookup(each.value, "action_groups", local.alert_action_group)
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "alerts_adx" {
  for_each = contains(["u", "p"], var.env_short) ? local.final_alerts_adx : tomap({})

  name                = each.value.name
  resource_group_name = local.monitor_rg
  location            = var.location

  scopes = [data.azurerm_kusto_database.idpay.id]

  description = each.value.description
  enabled     = lookup(try(each.value.enabled_by_env, {}), var.env_short, lookup(each.value, "enabled", true))
  severity    = lookup(try(each.value.severity_by_env, {}), var.env_short, each.value.severity)

  evaluation_frequency = each.value.evaluation_frequency == 1440 ? "P1D" : "PT${each.value.evaluation_frequency}M"
  window_duration      = each.value.window_duration == 1440 ? "P1D" : "PT${each.value.window_duration}M"

  identity {
    type = "SystemAssigned"
  }

  criteria {
    query                   = each.value.query
    time_aggregation_method = "Count"
    operator                = each.value.criteria.operator
    threshold               = each.value.criteria.threshold
  }

  action {
    action_groups = lookup(each.value, "action_groups", local.alert_action_group)
  }
}
