locals {
  product           = "${var.prefix}-${var.env_short}"
  product_no_domain = "${var.prefix}-${var.env_short}-${var.location_short}"
  project           = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_core      = "${var.prefix}-${var.env_short}-${var.location_short}-core"
  project_weu       = "${var.prefix}-${var.env_short}-${var.location_short_weu}-${var.domain}"
  project_entra     = "${var.prefix}-${var.env_short}-${var.domain}"

  # Default Domain Resource Group
  data_rg     = "${local.project}-data-rg"
  security_rg = "${local.project}-security-rg"
  compute_rg  = "${local.project}-compute-rg"
  cicd_rg     = "${local.project}-cicd-rg"
  monitor_rg  = "${local.project}-monitoring-rg"

  # SMTP
  ses_smtp_port = 465

  #
  # 🌐 Network
  #
  vnet_legacy_core_rg     = "${local.product}-vnet-rg"
  network_rg              = "${local.project_core}-network-rg"
  vnet_spoke_data_rg_name = "${local.project_core}-network-rg"
  vnet_spoke_data_name    = "${local.project_core}-spoke-data-vnet"
  vnet_spoke_compute_name = "${local.project_core}-spoke-compute-vnet"

  public_dns_zone_name = "${var.dns_zone_prefix}.${var.external_domain}"

  selfare_subdomain = "selfcare"

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
      "${var.env}.bonuselettrodomestici.eu",
      "${var.env}.bonuselettrodomestici.pagopa.it"
      ] : [
      "bonuselettrodomestici.it",
      "bonuselettrodomestici.com",
      "bonuselettrodomestici.info",
      "bonuselettrodomestici.io",
      "bonuselettrodomestici.net",
      "bonuselettrodomestici.eu",
      "bonuselettrodomestici.pagopa.it"
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
  aks_api_url             = data.azurerm_kubernetes_cluster.aks.private_fqdn


  ### ARGOCD
  argocd_namespace    = "argocd"
  argocd_internal_url = "argocd.${var.location_short}.${var.dns_zone_internal_prefix}.${var.external_domain}"

  # 🔎 DNS
  ingress_private_load_balancer_ip = "10.10.1.250"

  # AZDO
  azdo_managed_identity_rg_name = "${var.prefix}-${var.env_short}-identity-rg"
  azdo_iac_managed_identities_read = [
    "azdo-${var.env}-${var.prefix}-iac-plan-v2",
    "azdo-${var.env}-${var.prefix}-app-plan-v2",
  ]

  azdo_iac_managed_identities_write = [
    "azdo-${var.env}-${var.prefix}-iac-deploy-v2",
    "azdo-${var.env}-${var.prefix}-app-deploy-v2"
  ]


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

  mcshared_api_url           = "https://api-mcshared.${local.public_dns_zone_name}"
  keycloak_external_hostname = "${local.mcshared_api_url}/auth-itn"
  selfcare_issuer            = var.env == "prod" ? "https://selfcare.${var.external_domain}" : "https://${var.env}.selfcare.${var.external_domain}"


  # Data Factory
  data_factory_name    = "${local.product_no_domain}-platform-adf"
  data_factory_rg_name = "${local.product_no_domain}-platform-data-rg"
  adf_cosmosdb_linked_services = [
    azurerm_cosmosdb_mongo_database.databases["idpay-beneficiari"],
    azurerm_cosmosdb_mongo_database.databases["idpay-pagamenti"],
    azurerm_cosmosdb_mongo_database.databases["idpay-iniziative"],
    azurerm_cosmosdb_mongo_database.rdb
  ]

  # Data Explorer
  kusto_cluster_name    = "${local.product_no_domain}-platform"
  kusto_cluster_rg_name = "${local.product_no_domain}-platform-data-rg"
  kusto_database = {
    (var.domain) = {
      hot_cache_period   = "P5D"
      soft_delete_period = "P7D"
    }
  }

  # Action Group
  monitor_action_group_email_name = "pari-alerts-email"
}
