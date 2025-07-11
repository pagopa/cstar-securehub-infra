resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "monitoring_reloader" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = var.reloader_helm.chart_version
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
  set {
    name  = "reloader.deployment.image.name"
    value = var.reloader_helm.image_name
  }
  set {
    name  = "reloader.deployment.image.tag"
    value = var.reloader_helm.image_tag
  }
}

# Refer: Resource created on 30_core 02_monitor.tf
data "azurerm_monitor_workspace" "workspace" {
  name                = "${var.prefix}-${var.env_short}-${var.location}-monitor-workspace"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
}

module "prometheus_managed_addon" {
  source = "./.terraform/modules/__v4__/kubernetes_prometheus_managed"

  cluster_name           = module.aks.name
  resource_group_name    = module.aks.aks_resource_group_name
  location               = var.location
  location_short         = var.location_short
  monitor_workspace_name = data.azurerm_monitor_workspace.workspace.name
  monitor_workspace_rg   = data.azurerm_monitor_workspace.workspace.resource_group_name
  grafana_name           = "${var.prefix}-${var.env_short}-${var.location_short}-grafana"
  grafana_resource_group = "${var.prefix}-${var.env_short}-${var.location_short}-platform-monitoring-rg"

  # takes a list and replaces any elements that are lists with a
  # flattened sequence of the list contents.
  # In this case, we enable OpsGenie only on prod env
  action_groups_id = flatten([
    [
      data.azurerm_monitor_action_group.slack.id,
      data.azurerm_monitor_action_group.email.id
    ],
    (var.env == "prod" ? [
      data.azurerm_monitor_action_group.opsgenie.0.id
    ] : [])
  ])

  tags = local.tags
}
