locals {
  product       = "${var.prefix}-${var.env_short}"
  project       = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_core  = "${var.prefix}-${var.env_short}-${var.location_short}-core"
  project_entra = "${var.prefix}-${var.env_short}-${var.domain}"


  tags = merge(module.tag_config.tags, { grafana = "yes" })

  # 📊 Monitoring
  monitor_appinsights_name     = "${local.product}-appinsights"
  monitor_resource_group_name  = "${local.product}-monitor-rg"
  log_analytics_workspace_name = "${local.product}-law"
  monitor_action_group_slack   = "SlackPagoPA"
  monitor_action_group_email   = "PagoPA"

  vnet_legacy_name                = "${local.product}-vnet"
  vnet_legacy_resource_group_name = "${local.product}-vnet-rg"

  vnet_network_rg         = "${local.project_core}-network-rg"
  vnet_spoke_compute_name = "${local.project_core}-spoke-compute-vnet"
  vnet_spoke_data_name    = "${local.project_core}-spoke-data-vnet"

  internal_dns_zone_name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  internal_dns_zone_resource_group_name = "${local.product}-vnet-rg"

  cosmos_dns_zone_name                = "privatelink.mongo.cosmos.azure.com"
  cosmos_dns_zone_resource_group_name = "${local.product}-vnet-rg"


  # KV dominiale già esistente
  kv_domain_name    = "${local.project}-kv"
  kv_domain_rg_name = "${local.project}-security-rg"

  #
  # AKS
  #
  aks_name                = "${local.product}-${var.location_short}-${var.env}-aks"
  aks_resource_group_name = "${local.product}-${var.location_short}-core-aks-rg"

  ### ARGOCD
  argocd_namespace    = "argocd"
  argocd_internal_url = "argocd.${var.location_short}.${var.dns_zone_internal_prefix}.${var.external_domain}"

}
