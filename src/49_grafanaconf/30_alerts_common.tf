data "grafana_data_source" "grafana-azure-data-explorer-datasource" {
  provider = grafana.cloud
  name     = "grafana-azure-data-explorer-datasource"
}

resource "grafana_folder" "alert_folders" {
  provider = grafana.cloud
  for_each = toset(local.alert_folders)

  title = each.value
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
