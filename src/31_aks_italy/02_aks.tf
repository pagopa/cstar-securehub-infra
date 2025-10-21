resource "azurerm_resource_group" "aks_rg" {
  name     = "${local.project}-aks-rg"
  location = var.location

  tags = module.tag_config.tags
}

module "aks" {
  source = "./.terraform/modules/__v4__/kubernetes_cluster"
  # source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//kubernetes_cluster?ref=aks-ignore-workload-autoscale"

  name                       = local.aks_name
  location                   = var.location
  dns_prefix                 = local.project
  resource_group_name        = azurerm_resource_group.aks_rg.name
  kubernetes_version         = var.aks_kubernetes_version
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics.id
  sku_tier                   = var.aks_sku_tier

  workload_identity_enabled = true
  oidc_issuer_enabled       = true
  force_upgrade_enabled     = false

  ## Prometheus managed
  # ffppa: ⚠️ Installed on all ENV please do not change
  enable_prometheus_monitor_metrics = true

  # ffppa: Enabled cost analysis on UAT/PROD
  cost_analysis_enabled = var.env_short != "d" ? true : false

  #
  # 🤖 System node pool
  #
  system_node_pool_name = var.aks_system_node_pool.name
  ### vm configuration
  system_node_pool_vm_size         = var.aks_system_node_pool.vm_size
  system_node_pool_os_disk_type    = var.aks_system_node_pool.os_disk_type
  system_node_pool_os_disk_size_gb = var.aks_system_node_pool.os_disk_size_gb
  system_node_pool_node_count_min  = var.aks_system_node_pool.node_count_min
  system_node_pool_node_count_max  = var.aks_system_node_pool.node_count_max
  ### K8s node configuration
  system_node_pool_only_critical_addons_enabled = var.aks_system_node_pool.only_critical_addons_enabled
  system_node_pool_node_labels                  = var.aks_system_node_pool.node_labels
  system_node_pool_tags                         = var.aks_system_node_pool.node_tags

  #
  # ☁️ Network
  #
  vnet_id        = data.azurerm_virtual_network.vnet_compute_spoke.id
  vnet_subnet_id = module.aks_snet.id

  # outbound_ip_address_ids = azurerm_public_ip.aks_outbound.*.id
  private_cluster_enabled = var.aks_private_cluster_is_enabled
  network_profile = {
    dns_service_ip      = "172.20.0.10"
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium"
    network_policy      = "cilium"
    outbound_type       = "userAssignedNATGateway"
    service_cidr        = "172.20.0.0/16"
  }
  # end network

  aad_admin_group_ids = var.env_short == "p" ? [data.azuread_group.adgroup_admin.object_id] : [data.azuread_group.adgroup_admin.object_id, data.azuread_group.adgroup_developers.object_id, data.azuread_group.adgroup_externals.object_id]

  addon_azure_policy_enabled                     = true
  addon_azure_key_vault_secrets_provider_enabled = true

  alerts_enabled = var.aks_alerts_enabled

  # takes a list and replaces any elements that are lists with a
  # flattened sequence of the list contents.
  # In this case, we enable OpsGenie only on prod env
  action = flatten([
    [
      {
        action_group_id    = data.azurerm_monitor_action_group.slack.id
        webhook_properties = null
      },
      {
        action_group_id    = data.azurerm_monitor_action_group.email.id
        webhook_properties = null
      }
    ],
    (var.env == "prod" ? [
      {
        action_group_id    = data.azurerm_monitor_action_group.opsgenie.0.id
        webhook_properties = null
      }
    ] : [])
  ])

  microsoft_defender_log_analytics_workspace_id = var.env == "prod" ? data.azurerm_log_analytics_workspace.log_analytics.id : null

  automatic_channel_upgrade = null
  maintenance_windows_node_os = {
    enabled = true
  }

  tags = local.tags

}
