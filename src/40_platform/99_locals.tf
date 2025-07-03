locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product          = "${var.prefix}-${var.env_short}"
  product_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"

  #
  # Network
  #
  vnet_rg_name            = "${local.product_nodomain}-core-network-rg"
  vnet_core_hub_name      = "${local.product_nodomain}-core-hub-vnet"
  vnet_core_compute_name  = "${local.product_nodomain}-core-spoke-compute-vnet"
  vnet_core_data_name     = "${local.product_nodomain}-core-spoke-data-vnet"
  vnet_core_platform_name = "${local.product_nodomain}-core-spoke-platform-vnet"

  # pagopa peered vnet
  pagopa_cstar_integration_vnet_name    = "pagopa-${var.env_short}-itn-cstar-integration-vnet"
  pagopa_cstar_integration_vnet_rg_name = "pagopa-${var.env_short}-itn-vnet-rg"

  legacy_vnet_core_rg_name      = "${local.product}-vnet-rg"

  monitor_resource_group_name  = "${local.product_nodomain}-core-monitor-rg"
  log_analytics_workspace_name = "${local.product_nodomain}-core-law"

  #
  # KV
  #
  kv_cicd_name                = "${local.product_nodomain}-cicd-kv"
  kv_cicd_resource_group_name = "${local.product_nodomain}-core-sec-rg"

  kv_core_name                = "${local.product_nodomain}-core-kv"
  kv_core_resource_group_name = "${local.product_nodomain}-core-sec-rg"

  #
  # Domain urls
  #
  public_hostname           = var.env == "prod" ? "cstar.pagopa.it" : "${var.env}.cstar.pagopa.it"
  internal_private_hostname = var.env == "prod" ? "internal.cstar.pagopa.it" : "internal.${var.env}.cstar.pagopa.it"

  #
  # Domains to setup
  #
  domains_setup = {
    "platform" = {
      tags = {
        "CostCenter"   = "TS310 - PAGAMENTI & SERVIZI"
        "BusinessUnit" = "CStar"
        "Owner"        = "CStar"
        "Environment"  = var.env
        "CreatedBy"    = "Terraform"
        "Source"       = "https://github.com/pagopa/cstar-securehub-infra"
        "domain"       = "platform"
      }
      additional_resource_groups = [
        #"${local.product_nodomain}-idpay-azdo-rg"
      ]
    }
    "idpay" = {
      tags = {
        "CostCenter"   = "TS310 - PAGAMENTI & SERVIZI"
        "BusinessUnit" = "CStar"
        "Owner"        = "CStar"
        "Environment"  = var.env
        "CreatedBy"    = "Terraform"
        "Source"       = "https://github.com/pagopa/cstar-securehub-infra"
        "domain"       = "idpay"
      }
      additional_resource_groups = [
        #"${local.product_nodomain}-idpay-azdo-rg"
      ]
    }
    "srtp" = {
      tags = {
        "CostCenter"   = "TS310 - PAGAMENTI & SERVIZI"
        "BusinessUnit" = "CStar"
        "Owner"        = "CStar"
        "Environment"  = var.env
        "CreatedBy"    = "Terraform"
        "Source"       = "https://github.com/pagopa/cstar-securehub-infra"
        "domain"       = "srtp"
      }
      additional_resource_groups = [
        #"${local.product_nodomain}-idpay-azdo-rg"
      ]
    }
  }

}
