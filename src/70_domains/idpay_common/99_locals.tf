locals {
  project           = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_no_domain = "${var.prefix}-${var.env_short}-${var.location_short}"
  product           = "${var.prefix}-${var.env_short}"
  product_no_domain = "${var.prefix}-${var.env_short}-${var.location_short}"

  #
  # 🌐 Network
  #
  vnet_core_rg_name           = "${local.product}-vnet-rg"
  vnet_spoke_data_name        = "${local.project_no_domain}-core-spoke-data-vnet"
  vnet_spoke_data_rg_name     = "${local.project_no_domain}-core-network-rg"
  vnet_spoke_platform_rg_name = "${local.product_no_domain}-core-network-rg"
  vnet_spoke_platform_name    = "${local.product_no_domain}-core-spoke-platform-vnet"
  #
  # 🔑 KeyVault
  #
  idpay_kv_name    = "${local.project}-kv"
  idpay_kv_rg_name = "${local.project}-security-rg"

  #
  # AKS
  #
  aks_name                = "${local.project_no_domain}-${var.env}-aks"
  aks_resource_group_name = "${local.project_no_domain}-core-aks-rg"

  ### ARGOCD
  argocd_namespace    = "argocd"
  argocd_internal_url = "argocd.${var.location_short}.${var.dns_zone_internal_prefix}.${var.external_domain}"


  #
  # Monitoring
  #

  monitor_resource_group_name                 = "cstar-${var.env_short}-itn-core-monitor-rg"
  log_analytics_workspace_name                = "cstar-${var.env_short}-itn-core-law"
  application_insights_name = "cstar-${var.env_short}-itn-core-appinsights"

  platform_monitor_resource_group_name                 = "cstar-${var.env_short}-itn-platform-monitoring-rg"
  platform_log_analytics_workspace_name                = "cstar-${var.env_short}-itn-platform-monitoring-law"
  platform_application_insights_name = "cstar-${var.env_short}-itn-platform-monitoring-appinsights"

  #
  # APIM
  #
  apim_name    = "cstar-${var.env_short}-apim"
  apim_rg_name = "cstar-${var.env_short}-api-rg"
  # monitor_action_group_slack_name = "SlackPagoPA"
  # monitor_action_group_email_name = "PagoPA"
  #
  # vnet_core_name                = "${local.product}-vnet"
  # vnet_core_resource_group_name = "${local.product}-vnet-rg"
  #
  # container_registry_common_name    = "${local.project}-common-acr"
  # rg_container_registry_common_name = "${local.project}-container-registry-rg"
  #
  # core = {
  #   event_hub = {
  #     namespace_name      = "cstar-${var.env_short}-evh-ns"
  #     resource_group_name = "cstar-${var.env_short}-msg-rg"
  #   }
  # }
  #
  # azdo_managed_identity_rg_name = "${var.prefix}-${var.env_short}-identity-rg"
  # azdo_iac_managed_identities   = toset(["azdo-${var.env}-${var.prefix}-iac-deploy-v2", "azdo-${var.env}-${var.prefix}-iac-plan-v2"])

}
