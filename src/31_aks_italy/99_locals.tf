#
# General
#
locals {
  project      = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product      = "${var.prefix}-${var.env_short}-${var.location_short}"
  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"
  tenant_id    = data.azurerm_client_config.current.tenant_id

  #
  # AKS
  #
  aks_name                = "${local.product}-${var.env}-aks"
  aks_resource_group_name = "${local.project}-aks-rg"

  #
  # 🔐 KV
  #
  kv_name_cicd_security    = "${local.product}-cicd-kv"
  kv_name_core_security    = "${local.product}-core-kv"
  kv_rg_name_core_security = "${local.product}-core-sec-rg"

  #
  # 🌐 Network
  #
  dns_private_internal_name    = "${var.dns_zone_internal_prefix}.${var.prefix}.${var.external_domain}"
  dns_private_internal_rg_name = "${var.prefix}-${var.env_short}-vnet-rg"

  #
  # 🖥️ Monitor
  #
  monitor_rg_name                      = "${local.project}-monitor-rg"
  monitor_log_analytics_workspace_name = "${local.project}-law"
  monitor_log_analytics_workspace_rg   = "${local.project}-monitor-rg"
  monitor_appinsights_name             = "${local.project}-appinsights"

  #
  # 👤 Action groups
  #
  monitor_action_group_opsgenie_name = "CstarInfraOpsgenie"
  monitor_action_group_slack_name    = "SlackPagoPA"
  monitor_action_group_email_name    = "PagoPA"

  ### ARGOCD
  argocd_internal_url = "argocd.${var.location_short}.${var.dns_zone_internal_prefix}.${var.prefix}.${var.external_domain}"

}
