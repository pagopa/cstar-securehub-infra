locals {
  product       = "${var.prefix}-${var.env_short}"
  project       = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_core  = "${var.prefix}-${var.env_short}-${var.location_short}-core"
  project_entra = "${var.prefix}-${var.env_short}-${var.domain}"

  # 📊 Monitoring
  monitoring_rg_name = "${local.project}-monitoring-rg"

  monitor_action_group_slack = "SlackPagoPA"
  monitor_action_group_email = "PagoPA"

  vnet_legacy_resource_group_name = "${local.product}-vnet-rg"

  vnet_network_rg         = "${local.project_core}-network-rg"
  vnet_spoke_compute_name = "${local.project_core}-spoke-compute-vnet"
  vnet_spoke_data_name    = "${local.project_core}-spoke-data-vnet"

  # 🔎 DNS
  internal_dns_zone_name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  internal_dns_zone_resource_group_name = "${local.product}-vnet-rg"
  ingress_hostname_prefix               = "${var.domain}.${var.location_short}"
  domain_aks_hostname                   = var.env == "prod" ? "${local.ingress_hostname_prefix}.internal.cstar.pagopa.it" : "${local.ingress_hostname_prefix}.internal.${var.env}.cstar.pagopa.it"

  cosmos_dns_zone_name                = "privatelink.mongo.cosmos.azure.com"
  cosmos_dns_zone_resource_group_name = "${local.product}-vnet-rg"


  # KV
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

  # 🔗 API Management
  apim_name = "${local.product}-apim"
}
