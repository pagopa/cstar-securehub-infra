locals {
  product           = "${var.prefix}-${var.env_short}"
  product_no_domain = "${var.prefix}-${var.env_short}-${var.location_short}"
  project           = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_core      = "${var.prefix}-${var.env_short}-${var.location_short}-core"
  project_weu       = "${var.prefix}-${var.env_short}-${var.location_short_weu}-${var.domain}"

  # Default Domain Resource Group
  data_rg     = "${local.project}-data-rg"
  security_rg = "${local.project}}-security-rg"
  compute_rg  = "${local.project}}-compute-rg"
  cicd_rg     = "${local.project}}-cicd-rg"

  # SMTP
  ses_smtp_port = 465

  #
  # 🌐 Network
  #
  vnet_core_rg_name       = "${local.product}-vnet-rg"
  network_rg              = "${local.project_core}-network-rg"
  vnet_spoke_data_rg_name = "${local.project_core}-network-rg"
  vnet_spoke_data_name    = "${local.project_core}-spoke-data-vnet"
  vnet_spoke_compute_name = "${local.project_core}-spoke-compute-vnet"

  public_dns_zone_name = "${var.dns_zone_prefix}.${var.external_domain}"

  ########################################
  # Bonus Elettrodomestici DNS Public zone
  ########################################
  public_dns_zone_bonus_elettrodomestici = {
    zones = var.env_short != "p" ? [
      "${var.env}.bonuselettrodomestici.it",
      "${var.env}.bonuselettrodomestici.com",
      "${var.env}.bonuselettrodomestici.info",
      "${var.env}.bonuselettrodomestici.io",
      "${var.env}.bonuselettrodomestici.net",
      "${var.env}.bonuselettrodomestici.eu"
      ] : [
      "bonuselettrodomestici.it",
      "bonuselettrodomestici.com",
      "bonuselettrodomestici.info",
      "bonuselettrodomestici.io",
      "bonuselettrodomestici.net",
      "bonuselettrodomestici.eu"
    ]
  }

  #
  # 🔑 KeyVault
  #
  idpay_kv_name    = "${local.project}-kv"
  idpay_kv_rg_name = "${local.project}-security-rg"

  kv_core_name                = "${local.product_no_domain}-core-kv"
  kv_core_resource_group_name = "${local.product_no_domain}-core-sec-rg"
  #
  # AKS
  #
  aks_name                = "${local.product_no_domain}-${var.env}-aks"
  aks_resource_group_name = "${local.product_no_domain}-core-aks-rg"


  ### ARGOCD
  argocd_namespace    = "argocd"
  argocd_internal_url = "argocd.${var.location_short}.${var.dns_zone_internal_prefix}.${var.external_domain}"

  # 🔎 DNS
  ingress_private_load_balancer_ip = "10.10.1.250"

  #
  # Monitoring
  #

  monitor_resource_group_name       = "cstar-${var.env_short}-itn-core-monitor-rg"
  idpay_monitor_resource_group_name = "${local.project}-monitoring-rg"
  log_analytics_workspace_name      = "cstar-${var.env_short}-itn-core-law"
  application_insights_name         = "cstar-${var.env_short}-itn-core-appinsights"

  platform_monitor_resource_group_name  = "cstar-${var.env_short}-itn-platform-monitoring-rg"
  platform_log_analytics_workspace_name = "cstar-${var.env_short}-itn-platform-monitoring-law"
  platform_application_insights_name    = "cstar-${var.env_short}-itn-platform-monitoring-appinsights"

  core_monitor_resource_group_name  = "cstar-${var.env_short}-itn-core-monitor-rg"
  core_log_analytics_workspace_name = "cstar-${var.env_short}-itn-core-law"
  core_application_insights_name    = "cstar-${var.env_short}-itn-core-appinsights"


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


  keycloak_external_hostname = "https://${var.mcshared_dns_zone_prefix}.${var.prefix}.${var.external_domain}/auth-itn"

  keycloak_bonus_hostname = "https://${var.env}.bonuselettrodomestici.it"
}
