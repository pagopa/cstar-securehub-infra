locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}"

  monitor_appinsights_name        = "${local.product}-appinsights"
  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"
  alert_action_group_domain_name  = "${var.prefix}${var.env_short}${var.domain}"

  #
  # 🌐 Network
  #
  dns_private_internal_name    = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  dns_private_internal_rg_name = "${var.prefix}-${var.env_short}-vnet-rg"

  ingress_hostname_prefix               = "${var.instance}.${var.domain}"
  internal_dns_zone_name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  internal_dns_zone_resource_group_name = "${local.product}-vnet-rg"

  ### ARGOCD
  argocd_internal_url = "argocd.${var.location_short}.${var.dns_zone_internal_prefix}.${var.external_domain}"
  argocd_domain_project_name = "${var.domain}-project"

  #
  # 🔑 KeyVault
  #
  idpay_kv_name    = "${local.project}-kv"
  idpay_kv_rg_name = "${local.project}-security-rg"

  #
  # AKS
  #
  aks_name                = "${local.product}-${var.location_short}-${var.env}-aks"
  aks_resource_group_name = "${local.product}-${var.location_short}-core-aks-rg"
  # DOMAINS
  domain_namespace        = var.domain
  argocd_namespace       = "argocd"



  apim_rg_name                  = "cstar-${var.env_short}-api-rg"
  apim_name                     = "cstar-${var.env_short}-apim"
  # apim_logger_id                = "${data.azurerm_api_management.apim_core.id}/loggers/${local.apim_name}-logger"
  vnet_core_name                = "${local.product}-vnet"
  vnet_core_resource_group_name = "${local.product}-vnet-rg"


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

  idpay_eventhubs = {
    evh01 = {
      namespace           = "${local.product}-${var.domain}-evh-ns-01"
      resource_group_name = "${local.product}-${var.domain}-msg-rg"
    }
    evh00 = {
      namespace           = "${local.product}-${var.domain}-evh-ns-00"
      resource_group_name = "${local.product}-${var.domain}-msg-rg"
    }
  }

  # domain_aks_hostname                      = var.env == "prod" ? "${var.instance}.${var.domain}.internal.cstar.pagopa.it" : "${var.instance}.${var.domain}.internal.${var.env}.cstar.pagopa.it"
  # rtd_domain_aks_hostname                  = var.env == "prod" ? "${var.instance}.rtd.internal.cstar.pagopa.it" : "${var.instance}.rtd.internal.${var.env}.cstar.pagopa.it"
  # rtd_ingress_load_balancer_hostname_https = "https://${local.rtd_domain_aks_hostname}"
  # initiative_storage_fqdn                  = "${module.idpay_initiative_storage.name}.blob.core.windows.net"
  # reward_storage_fqdn                      = "${module.idpay_refund_storage.name}.blob.core.windows.net"

  # ingress_load_balancer_https = "https://${var.ingress_load_balancer_hostname}"
}
