locals {
  project      = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product      = "${var.prefix}-${var.env_short}"
  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"

  vnet_name                = "${local.project_core}-vnet"
  vnet_resource_group_name = "${local.project_core}-vnet-rg"

  # AKS
  aks_name                 = "${local.project}-aks"
  aks_resource_group_name  = "${local.project}-aks-rg"
  ingress_load_balancer_ip = cidrhost(var.aks_cidr_user_subnet[0], -6)

  # Monitor
  monitor_resource_group_name     = "${local.project_core}-monitor-rg"
  log_analytics_workspace_name    = "${local.project_core}-law"
  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"

  # ACR DOCKER
  docker_rg_name       = "${local.project_core}-container-registry-rg"
  docker_registry_name = replace("${local.project_core}-common-acr", "-", "")

  # DNS
  internal_dns_zone_name                = "${var.dns_zone_internal_prefix}.${var.prefix}.${var.external_domain}"
  internal_dns_zone_resource_group_name = "${local.project_core}-vnet-rg"
  ingress_hostname_prefix               = "hub"

  ### ARGOCD
  argocd_internal_url = "argocd.${var.dns_zone_internal_prefix}.${var.prefix}.${var.external_domain}"
  ingress_artemis_url = "artemis.${local.internal_dns_zone_name}"

  #
  # 🔐 KV
  #
  kv_id_core            = data.azurerm_key_vault.key_vault_core.id
  kv_name_core          = "${local.project_core}-kv"
  rg_name_core_security = "${local.project_core}-sec-rg"

}
