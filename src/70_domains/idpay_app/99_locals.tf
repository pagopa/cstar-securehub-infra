locals {
  project      = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"
  product      = "${var.prefix}-${var.env_short}"

  monitor_appinsights_name        = "${local.product}-appinsights"
  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"
  alert_action_group_domain_name  = "${var.prefix}${var.env_short}${var.domain}"

  #
  # 🌐 Network
  #
  dns_private_internal_name    = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  dns_private_internal_rg_name = "${var.prefix}-${var.env_short}-vnet-rg"

  internal_dns_zone_name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  internal_dns_zone_resource_group_name = "${local.product}-vnet-rg"

  ### ARGOCD
  argocd_internal_url         = "argocd.${var.location_short}.${var.dns_zone_internal_prefix}.${var.external_domain}"
  argocd_domain_project_name  = "${var.domain}-project"
  argocd_idpay_apps_namespace = "argocd"

  #
  # 🔑 KeyVault
  #
  idpay_kv_name    = "${local.project}-kv"
  idpay_kv_rg_name = "${local.project}-security-rg"

  secret_name_idpay_workload_identity_client_id            = "idpay-itn-workload-identity-client-id"
  secret_name_idpay_workload_identity_service_account_name = "idpay-itn-workload-identity-service-account-name"

  #
  # AKS
  #
  aks_name                = "${local.product}-${var.location_short}-${var.env}-aks"
  aks_resource_group_name = "${local.product}-${var.location_short}-core-aks-rg"

  # DOMAINS
  domain_namespace = var.domain
  data_rg_name     = "${local.project}-data-rg"

  #
  # IDPAY
  #
  idpay_ingress_url = "${var.domain}.${var.location_short}.${var.dns_zone_internal_prefix}.${var.external_domain}"

  #
  # Eventhub
  #
  eventhub_00_namespace_name  = "${local.project}-evh-00-ns"
  eventhub_01_namespace_name  = "${local.project}-evh-01-ns"
  eventhub_02_namespace_name  = "${local.project}-evh-02-ns"
  eventhub_rdb_namespace_name = "${local.project}-evh-rdb-ns"
  eventhub_00_url             = "${local.eventhub_00_namespace_name}.servicebus.windows.net:${var.event_hub_port}"
  eventhub_01_url             = "${local.eventhub_01_namespace_name}.servicebus.windows.net:${var.event_hub_port}"
  eventhub_02_url             = "${local.eventhub_02_namespace_name}.servicebus.windows.net:${var.event_hub_port}"
  eventhub_rdb_url            = "${local.eventhub_rdb_namespace_name}.servicebus.windows.net:${var.event_hub_port}"


  #
  # Monitoring
  #
  monitoring_rg_name                = "${local.project}-monitoring-rg"
  monitor_rg                        = local.monitoring_rg_name
  core_monitoring_rg_name           = "${local.project_core}-monitor-rg"
  core_app_insights_name            = "${local.project_core}-appinsights"
  monitor_alert_email_group_name    = "pari-alerts-email"
  monitor_alert_opsgenie_group_name = "IdpayOpsgenie"

  #ORIGINS (used for CORS on IDPAY Welfare Portal)
  origins = {
    base = concat(
      [
        # "https://portal.${data.azurerm_dns_zone.public.name}",
        # "https://management.${data.azurerm_dns_zone.public.name}",
        # "https://${local.apim_name}.developer.azure-api.net",
        # "https://${local.idpay-portal-hostname}",
      ],
      var.env_short != "p" ? ["https://localhost:3000", "http://localhost:3000", "https://localhost:3001", "http://localhost:3001"] : []
    )
  }
}

# DATA FACTORY
data_factory_resource_group_name = "${var.prefix}-${var.env_short}-${var.location_short}-platform-data-rg"
data_factory_name = "${var.prefix}-${var.env_short}-${var.location_short}-itn-platform-adf"
