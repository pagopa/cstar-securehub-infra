locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product          = "${var.prefix}-${var.env_short}"
  product_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"
  product_core     = "${var.prefix}-${var.env_short}-${var.location_short}-core"

  enable_temporal_io = var.env == "dev" ? 1 : 0

  #
  # AKS
  #
  aks_name                 = "${var.prefix}-${var.env_short}-${var.location_short}-${var.env}-aks"
  aks_resource_group_name  = "${local.aks_name}-rg"
  ingress_load_balancer_ip = cidrhost(var.aks_cidr_user_subnet[0], -6)

  #
  # 🔐 KV
  #
  kv_id_core            = data.azurerm_key_vault.key_vault_core.id
  kv_name_core          = "${local.product_core}-kv"
  rg_name_core_security = "${local.product_core}-sec-rg"

  #
  # DNS
  #
  internal_dns_zone_name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  internal_dns_zone_resource_group_name = "${local.product_core}-vnet-rg"

  #
  # Artemis
  #
  ingress_artemis_url = "artemis.${local.internal_dns_zone_name}"

  ### Network
  web_temporal_internal_url = "web.temporal.${var.dns_zone_internal_prefix}.${var.external_domain}"
  api_temporal_internal_url = "api.temporal.${var.dns_zone_internal_prefix}.${var.external_domain}"

  ingress_private_load_balancer_ip = "10.1.1.250"

  ### Monitor
  monitor_resource_group_name  = "${local.product_core}-monitor-rg"
  log_analytics_workspace_name = "${local.product_core}-law"

  force_temporal_postgres_setup = "v20241122_1"

}
