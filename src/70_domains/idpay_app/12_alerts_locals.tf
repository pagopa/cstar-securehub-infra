# =============================================================
# Alert API EIE
# =============================================================

locals {
  alert_action_group = compact([
    try(data.azurerm_monitor_action_group.alerts_email[0].id, null),
    var.env_short == "p" ? try(data.azurerm_monitor_action_group.alerts_opsgenie[0].id, null) : null
  ])

  alert_defaults = {
    enabled        = true
    severity       = 1
    frequency      = 5
    time_window    = 5
    data_source_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  }

  # Data sources that alerts can reference from the YAML descriptors
  alert_data_sources = {
    log_analytics_workspace = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
    core_app_insights       = data.azurerm_application_insights.core_app_insights.id
  }

  # Tokens that can be used inside query templates (defaults to the data sources map)
  alert_query_arg_values = local.alert_data_sources

  # Load every YAML file in alert_definitions/ (one macro-category per file)
  alert_definition_files = sort(fileset("${path.module}/alert_definitions", "*.yaml"))

  alerts_from_yaml = flatten([
    for file_name in local.alert_definition_files : [
      for alert in yamldecode(file("${path.module}/alert_definitions/${file_name}")).alerts : merge(alert, {
        macro_category      = trimsuffix(file_name, ".yaml")
        category_path       = lookup(alert, "category_path", [])
        query_template_args = lookup(alert, "query_template_args", [])
      })
    ]
  ])

  alerts_with_data = [
    for alert in local.alerts_from_yaml : merge(alert, {
      data_source_id = lookup(
        local.alert_data_sources,
        lookup(alert, "data_source", "log_analytics_workspace"),
        local.alert_defaults.data_source_id
      ),
      query = contains(alert, "query_template") ? (
        length(alert.query_template_args) == 0 ? alert.query_template :
        length(alert.query_template_args) == 1 ? format(
          alert.query_template,
          lookup(local.alert_query_arg_values, alert.query_template_args[0], alert.query_template_args[0])
        ) :
        length(alert.query_template_args) == 2 ? format(
          alert.query_template,
          lookup(local.alert_query_arg_values, alert.query_template_args[0], alert.query_template_args[0]),
          lookup(local.alert_query_arg_values, alert.query_template_args[1], alert.query_template_args[1])
        ) :
        length(alert.query_template_args) == 3 ? format(
          alert.query_template,
          lookup(local.alert_query_arg_values, alert.query_template_args[0], alert.query_template_args[0]),
          lookup(local.alert_query_arg_values, alert.query_template_args[1], alert.query_template_args[1]),
          lookup(local.alert_query_arg_values, alert.query_template_args[2], alert.query_template_args[2])
        ) :
        alert.query_template
      ) : alert.query
    })
  ]

  alert_definitions = {
    for alert in local.alerts_with_data : alert.key => merge(local.alert_defaults, alert)
  }
}
