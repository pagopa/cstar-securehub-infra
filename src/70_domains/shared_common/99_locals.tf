locals {
  product           = "${var.prefix}-${var.env_short}"
  project           = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_no_domain = "${var.prefix}-${var.env_short}-${var.location_short}"


  # AKS
  aks_name                = "${local.project_no_domain}-${var.env}-aks"
  aks_resource_group_name = "${local.project_no_domain}-core-aks-rg"

  # 🔐 KV
  key_vault_name    = "${local.project}-kv"
  key_vault_rg_name = "${local.project}-security-rg"

  # 🔎 DNS
  dns_zone_name                    = "${var.env != "prod" ? "${var.env}." : ""}${var.prefix}.pagopa.it"
  dns_zone_internal                = "internal.${local.dns_zone_name}"
  ingress_hostname                 = "${var.domain}.${var.location_short}.${local.dns_zone_internal}"
  ingress_private_load_balancer_ip = "10.10.1.250"


  ### ARGOCD
  argocd_namespace    = "argocd"
  argocd_internal_url = "argocd.${var.location_short}.${local.dns_zone_internal}"

  # Default Domain Resource Group
  data_rg_name    = "${local.project}-data-rg"
  monitor_rg_name = "${local.project}-monitoring-rg"

  # APIM
  apim_name    = "${local.product}-apim"
  apim_rg_name = "${local.product}-api-rg"
  aks_api_url  = data.azurerm_kubernetes_cluster.aks.private_fqdn

  # VNET
  vnet_legacy_core_rg = "${local.product}-vnet-rg"
}
