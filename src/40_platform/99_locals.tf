locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product          = "${var.prefix}-${var.env_short}"
  product_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"
  project_core     = "${var.prefix}-${var.env_short}-${var.location_short}-core"

  #
  # Network
  #
  vnet_rg_name            = "${local.product_nodomain}-core-network-rg"
  vnet_core_hub_name      = "${local.product_nodomain}-core-hub-vnet"
  vnet_core_compute_name  = "${local.product_nodomain}-core-spoke-compute-vnet"
  vnet_core_data_name     = "${local.product_nodomain}-core-spoke-data-vnet"

  dns_private_internal_name    = "${var.dns_zone_internal_prefix}.${var.prefix}.${var.external_domain}"
  dns_private_internal_rg_name = "${var.prefix}-${var.env_short}-vnet-rg"

  ingress_load_balancer_ip  = "10.10.1.250"


  # pagopa peered vnet
  pagopa_cstar_integration_vnet_name    = "pagopa-${var.env_short}-itn-cstar-integration-vnet"
  pagopa_cstar_integration_vnet_rg_name = "pagopa-${var.env_short}-itn-vnet-rg"

  legacy_vnet_core_rg_name = "${local.product}-vnet-rg"

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

  ### AKS -----------------------------------------------------------------------
  aks_cluster_name = "cstar-${var.env_short}-itn-dev-aks"
  aks_resource_group_name = "cstar-${var.env_short}-itn-core-aks-rg"

  ### ARGOCD
  argocd_internal_url = "argocd.${var.location_short}.${var.dns_zone_internal_prefix}.${var.prefix}.${var.external_domain}"

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
    "mcshared" = {
      tags = {
        "CostCenter"   = "TS310 - PAGAMENTI & SERVIZI"
        "BusinessUnit" = "CStar"
        "Owner"        = "CStar"
        "Environment"  = var.env
        "CreatedBy"    = "Terraform"
        "Source"       = "https://github.com/pagopa/cstar-securehub-infra"
        "domain"       = "mcshared"
      }
      additional_resource_groups = []
    }
  }
}
