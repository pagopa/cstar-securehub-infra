locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product          = "${var.prefix}-${var.env_short}"
  product_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"
  project_core     = "${var.prefix}-${var.env_short}-${var.location_short}-core"

  #
  # 🌐 Network
  #
  vnet_compute_name    = "${local.product_nodomain}-core-spoke-compute-vnet"
  vnet_data_name       = "${local.product_nodomain}-core-spoke-data-vnet"
  vnet_network_rg_name = "${local.product_nodomain}-core-network-rg"

  subnet_postgres_name     = "${local.product_nodomain}-platform-postgres-snet"
  legacy_vnet_core_rg_name = "${local.product}-vnet-rg"


  dns_private_internal_name    = "${var.dns_zone_internal_prefix}.${var.prefix}.${var.external_domain}"
  dns_private_internal_rg_name = "${var.prefix}-${var.env_short}-vnet-rg"


  # RG
  platform_data_rg_name = "${local.product_nodomain}-platform-data-rg"

  kv_core_name                = "${local.product_nodomain}-core-kv"
  kv_core_resource_group_name = "${local.product_nodomain}-core-sec-rg"

  ### Monitoring
  monitoring_rg_name = "${local.project}-monitoring-rg"
  law_name           = "${local.project}-monitoring-law"

  core_monitor_rg_name   = "${local.product_nodomain}-core-monitor-rg"
  app_insights_core_name = "${local.product_nodomain}-core-appinsights"

  # Keycloak
  keycloak_db_name           = "bitnami_keycloak"
  keycloak_ingress_hostname  = "keycloak.${var.location_short}.${var.dns_zone_internal_prefix}.${var.prefix}.${var.external_domain}"
  keycloak_external_hostname = "https://${var.mcshared_dns_zone_prefix}.${var.prefix}.${var.external_domain}/auth-itn"

  #
  # AKS
  #
  aks_name                = "${local.product}-${var.location_short}-${var.env}-aks"
  aks_resource_group_name = "${local.product}-${var.location_short}-core-aks-rg"

  aks_ingress_load_balancer_ip = "10.10.1.250"
}
