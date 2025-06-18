locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product          = "${var.prefix}-${var.env_short}"
  product_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"

  # VNET
  vnet_data_name            = "${local.product_nodomain}-core-spoke-data-vnet"
  vnet_network_rg_name         = "${local.product_nodomain}-core-network-rg"

  subnet_postgres_name                = "${local.product_nodomain}-platform-postgres-snet"
  legacy_vnet_core_rg_name      = "${local.product}-vnet-rg"

  # RG
  platform_data_rg_name = "${local.product_nodomain}-platform-data-rg"

  kv_core_name                = "${local.product_nodomain}-core-kv"
  kv_core_resource_group_name = "${local.product_nodomain}-core-sec-rg"

  ### Monitoring
  monitoring_rg_name = "${local.project}-monitoring-rg"
  law_name = "${local.project}-monitoring-law"
  app_insights_name = "${local.project}-monitoring-appinsights"

    # Keycloak
  keycloak_db_name = "bitnami_keycloak"
  keycloak_ingress_hostname = "keycloak.itn.internal.dev.cstar.pagopa.it"
}
