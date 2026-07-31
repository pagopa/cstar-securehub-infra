data "grafana_data_source" "grafana-azure-data-explorer-datasource" {
  provider = grafana.cloud
  name     = "grafana-azure-data-explorer-datasource"
}

locals {
  alert_folders = merge([
    for product, configuration in local.team_product : {
      for folder in configuration.alert_folders :
      "${product}-${folder}" => folder
    }
  ]...)
}

resource "grafana_folder" "alert" {
  provider = grafana.cloud
  for_each = local.alert_folders

  title = each.value
}

moved {
  from = grafana_folder.idpay_app_alerts[0]
  to   = grafana_folder.alert["idpay-IDPay App Alerts"]
}

resource "grafana_mute_timing" "working_hours" {
  provider = grafana.cloud
  count    = var.idpay_grafana_alert_enabled ? 1 : 0

  name = local.grafana_mute_timing_name
  intervals {

    times {
      start = "09:00"
      end   = "18:00"
    }

    weekdays = ["monday", "tuesday", "wednesday", "thursday", "friday"]
    location = "Europe/Rome"
  }
}
