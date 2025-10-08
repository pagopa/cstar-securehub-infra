locals {
  product          = "${var.prefix}-${var.env_short}"
  project_location = "${var.prefix}-${var.env_short}-${var.location_short}"
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"

  tags = module.tag_config.tags

  # 📊 Monitoring
  monitor_appinsights_name     = "${local.product}-appinsights"
  monitor_resource_group_name  = "${local.product}-monitor-rg"
  log_analytics_workspace_name = "${local.product}-law"
  monitor_action_group_slack   = "SlackPagoPA"
  monitor_action_group_email   = "PagoPA"

  vnet_core_name                = "${local.product}-vnet"
  vnet_core_resource_group_name = "${local.product}-vnet-rg"

  ingress_hostname                      = "${var.location_short}${var.env}.${var.domain}"
  internal_dns_zone_name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  internal_dns_zone_resource_group_name = "${local.product}-vnet-rg"

  cosmos_dns_zone_name                = "privatelink.mongo.cosmos.azure.com"
  cosmos_dns_zone_resource_group_name = "${local.product}-vnet-rg"

  eventhub_resource_group_name = "${local.project}-evh-rg"

  # KV dominiale già esistente
  kv_domain_name    = "${local.project}-kv"
  kv_domain_rg_name = "${local.project}-security-rg"

  #
  # AKS
  #
  aks_name                = "${local.product}-${var.location_short}-${var.env}-aks"
  aks_resource_group_name = "${local.product}-${var.location_short}-core-aks-rg"

}
