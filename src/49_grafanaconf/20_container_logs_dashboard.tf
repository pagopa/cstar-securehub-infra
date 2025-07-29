
resource "grafana_team" "teams" {
  provider = grafana.cloud
  for_each = local.team_product
  name     = "${each.key}-team"

  lifecycle {
    ignore_changes = [
      members
    ]
  }

}

resource "grafana_folder" "teams" {
  provider = grafana.cloud
  title    = "${upper(var.prefix)}-Products-Logs"
}

resource "grafana_folder_permission" "admin_permission" {
  provider   = grafana.cloud
  folder_uid = grafana_folder.teams.uid
  permissions {
    role       = "Admin"
    permission = "Admin"
  }
}

resource "grafana_folder" "team_dashboard_folder" {
  provider          = grafana.cloud
  for_each          = local.team_product
  parent_folder_uid = grafana_folder.teams.uid
  title             = "${upper(var.prefix)}-${upper(each.key)}"
}

resource "grafana_folder_permission" "aks_container_logs_reader" {
  provider   = grafana.cloud
  for_each   = local.team_product
  folder_uid = grafana_folder.team_dashboard_folder[each.key].uid

  permissions {
    team_id    = grafana_team.teams[each.key].id
    permission = "View"
  }
}

resource "grafana_dashboard" "aks_container_logs_dashboard" {
  provider = grafana.cloud
  for_each = { for product, type in local.team_product : product => type.aks if can(type.aks) }


  config_json = templatefile(
    "${path.module}/custom_dashboard/Cstar_AKS_Container_logs.json",
    {
      env                  = var.env,
      env_short            = var.env_short,
      location_short       = each.value.location_short,
      namespace            = each.key,
      subscription         = data.azurerm_subscription.current.id,
      monitor_workspace_id = each.value.monitor_workspace_id,
      aks_name             = each.value.aks_name
    }
  )
  folder    = grafana_folder.team_dashboard_folder[each.key].uid
  overwrite = true
}

resource "grafana_dashboard" "aca_container_logs_dashboard" {
  provider = grafana.cloud
  for_each = { for product, type in local.team_product : product => type.aca if can(type.aca) }


  config_json = templatefile(
    "${path.module}/custom_dashboard/Cstar_ACA_Container_logs.json",
    {
      env                  = var.env,
      env_short            = var.env_short,
      location_short       = each.value.location_short,
      namespace            = each.key,
      subscription         = data.azurerm_subscription.current.id,
      monitor_workspace_id = each.value.monitor_workspace_id
    }
  )
  folder    = grafana_folder.team_dashboard_folder[each.key].uid
  overwrite = true
}
