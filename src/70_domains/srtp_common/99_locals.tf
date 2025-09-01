locals {
  # General
  project           = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_core      = "${var.prefix}-${var.env_short}-${var.location_short}-core"
  project_no_domain = "${var.prefix}-${var.env_short}-${var.location_short}"
  product           = "${var.prefix}-${var.env_short}"

  # Default Domain Resource Group
  data_rg_name     = "${local.project}-data-rg"
  security_rg_name = "${local.project}-security-rg"
  compute_rg_name  = "${local.project}-compute-rg"
  cicd_rg_name     = "${local.project}-cicd-rg"
  monitor_rg_name  = "${local.project}-monitoring-rg"
  identity_rg_name = "${local.project}-identity-rg"


  default_resource_group_names = [
    local.data_rg_name,
    local.security_rg_name,
    local.compute_rg_name,
    local.cicd_rg_name,
    local.monitor_rg_name,
    local.identity_rg_name
  ]

  # 🛜 VNET + Subnets
  network_rg              = "${local.project_core}-network-rg"
  vnet_spoke_data_name    = "${local.project_core}-spoke-data-vnet"
  vnet_spoke_compute_name = "${local.project_core}-spoke-compute-vnet"
  vnet_legacy_core_rg     = "${local.product}-vnet-rg"

  # APIM
  apim_name    = "${local.product}-apim"
  apim_rg_name = "${local.product}-api-rg"

  # 🔐 KV
  key_vault_name    = "${local.project}-kv"
  key_vault_rg_name = "${local.project}-security-rg"

  # 🔎 DNS
  dns_zone_name                    = "${var.env != "prod" ? "${var.env}." : ""}${var.prefix}.pagopa.it"
  dns_zone_internal                = "internal.${local.dns_zone_name}"
  ingress_private_load_balancer_ip = "10.10.1.250"

  repositories = ["rtp-sender", "rtp-activator"]

  # AKS
  aks_name                = "${local.project_no_domain}-${var.env}-aks"
  aks_resource_group_name = "${local.project_no_domain}-core-aks-rg"
  aks_api_url             = var.env_short == "d" ? data.azurerm_kubernetes_cluster.aks.fqdn : data.azurerm_kubernetes_cluster.aks.private_fqdn

  # 🍀 Cosmos DB Collection
  cosmos_db = {
    rtp = {
      rtps = {
        indexes = [
          {
            keys   = ["_id"]
            unique = true
          }
        ]
      }
    }
    activation = {
      activations = {
        indexes = [
          {
            keys   = ["_id"]
            unique = true
          },
          {
            keys   = ["fiscalCode"]
            unique = true
          }
        ]
      }
      deleted_activations = {
        indexes = [
          {
            keys   = ["_id"]
            unique = true
          }
        ]
      }
    }
  }
  cosmos_collections = flatten([
    for db_name, db in local.cosmos_db : [
      for coll_name, coll in db : {
        db_name   = db_name
        coll_name = coll_name
        indexes   = coll.indexes
      }
    ]
  ])
}
