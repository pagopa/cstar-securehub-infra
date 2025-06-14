locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product          = "${var.prefix}-${var.env_short}"
  product_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"

  #
  # Monitoring
  #
  monitoring_rg_name = "cstar-${var.env_short}-itn-platform-monitoring-rg"
  law_name                = "${local.project}-monitoring-law"
  grafana_name = "cstar-${var.env_short}-itn-grafana"

  #
  # KV
  #
  kv_cicd_name                = "${local.product_nodomain}-cicd-kv"
  kv_cicd_resource_group_name = "${local.product_nodomain}-core-sec-rg"

  kv_core_name                = "${local.product_nodomain}-core-kv"
  kv_core_resource_group_name = "${local.product_nodomain}-core-sec-rg"
}
