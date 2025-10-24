locals {
  ref_group_names_by_team = {
    for team, groups in var.team_groups :
    team => {
      admin      = try(element(compact([for k in keys(groups) : endswith(k, "-adgroup-admin") ? k : ""]), 0), null)
      developers = try(element(compact([for k in keys(groups) : endswith(k, "-adgroup-developers") ? k : ""]), 0), null)
      externals  = try(element(compact([for k in keys(groups) : endswith(k, "-adgroup-externals") ? k : ""]), 0), null)
      oncall     = try(element(compact([for k in keys(groups) : endswith(k, "-adgroup-oncall") ? k : ""]), 0), null)
    }
  }

  role_permissions_by_team = {
    for team, refs in local.ref_group_names_by_team :
    team => {
      admin      = try(var.team_groups[team][refs.admin].permission, null)
      developers = try(var.team_groups[team][refs.developers].permission, null)
      externals  = try(var.team_groups[team][refs.externals].permission, null)
      oncall     = try(var.team_groups[team][refs.oncall].permission, null)
    }
  }

  teams_with_groups = {
    for t, cfg in local.team_product :
    t => cfg if contains(keys(local.ref_group_names_by_team), t)
  }

  team_role_defs = merge([
    for team, _ in local.teams_with_groups : {
      "${team}:admin"  = { team = team, name = "${team}-admin", role = "admin" }
      "${team}:dev"    = { team = team, name = "${team}-developers", role = "developers" }
      "${team}:ext"    = { team = team, name = "${team}-externals", role = "externals" }
      "${team}:oncall" = { team = team, name = "${team}-oncall", role = "oncall" }
    }
  ]...)

  role_permissions_effective = {
    for team, perms in local.role_permissions_by_team :
    team => merge(
      perms.admin != null ? { admin = perms.admin } : {},
      perms.developers != null ? { dev = perms.developers } : {},
      perms.externals != null ? { ext = perms.externals } : {},
      perms.oncall != null ? { ext = perms.oncall } : {}
    )
  }

  role_team_ids_by_team = {
    for team, _ in local.teams_with_groups :
    team => merge(
      try({ admin = grafana_team.team_roles["${team}:admin"].id }, {}),
      try({ dev = grafana_team.team_roles["${team}:dev"].id }, {}),
      try({ ext = grafana_team.team_roles["${team}:ext"].id }, {}),
      try({ oncall = grafana_team.team_roles["${team}:oncall"].id }, {})
    )
  }
}

data "azuread_group" "ref_by_display_name" {
  for_each = merge([
    for team, refs in local.ref_group_names_by_team : {
      for pair in [
        { key = "${team}:admin", name = refs.admin },
        { key = "${team}:developers", name = refs.developers },
        { key = "${team}:externals", name = refs.externals },
        { key = "${team}:oncall", name = refs.oncall }
      ] : pair.key => pair if pair.name != null
    }
  ]...)
  display_name     = each.value.name
  security_enabled = true
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
  permissions {
    role       = "Viewer"
    permission = "View"
  }
}

resource "grafana_team" "team_roles" {
  provider = grafana.cloud
  for_each = local.team_role_defs
  name     = each.value.name

  team_sync {
    groups = compact([
      try(data.azuread_group.ref_by_display_name["${each.value.team}:${each.value.role}"].object_id, null)
    ])
  }
}

resource "grafana_folder" "team_dashboard_folder" {
  provider          = grafana.cloud
  for_each          = local.team_product
  parent_folder_uid = grafana_folder.teams.uid
  title             = "${upper(var.prefix)}-${upper(each.key)}"
}

resource "grafana_folder_permission" "team_role_permissions" {
  provider   = grafana.cloud
  for_each   = local.teams_with_groups
  folder_uid = grafana_folder.team_dashboard_folder[each.key].uid

  dynamic "permissions" {
    for_each = {
      for role, perm in lookup(local.role_permissions_effective, each.key, {}) :
      role => {
        team_id    = lookup(local.role_team_ids_by_team[each.key], role, null)
        permission = perm
      }
      if lookup(local.role_team_ids_by_team[each.key], role, null) != null
    }
    content {
      team_id    = permissions.value.team_id
      permission = permissions.value.permission
    }
  }
}


# AKS Dashboard
resource "grafana_dashboard" "aks_container_logs_dashboard" {
  provider = grafana.cloud
  for_each = { for product, type in local.team_product : product => type.aks if can(type.aks) }
  config_json = templatefile("${path.module}/custom_dashboard/Cstar_AKS_Container_logs.json", {
    env                  = var.env,
    env_short            = var.env_short,
    location_short       = each.value.location_short,
    namespace            = each.key,
    subscription         = data.azurerm_subscription.current.id,
    monitor_workspace_id = each.value.monitor_workspace_id,
    aks_name             = each.value.aks_name
  })
  folder    = grafana_folder.team_dashboard_folder[each.key].uid
  overwrite = true
}

# ACA dashboards
resource "grafana_dashboard" "aca_container_logs_dashboard" {
  provider = grafana.cloud
  for_each = { for product, type in local.team_product : product => type.aca if can(type.aca) }
  config_json = templatefile("${path.module}/custom_dashboard/Cstar_ACA_Container_logs.json", {
    env                  = var.env,
    env_short            = var.env_short,
    location_short       = each.value.location_short,
    namespace            = each.key,
    subscription         = data.azurerm_subscription.current.id,
    monitor_workspace_id = each.value.monitor_workspace_id
  })
  folder    = grafana_folder.team_dashboard_folder[each.key].uid
  overwrite = true
}
