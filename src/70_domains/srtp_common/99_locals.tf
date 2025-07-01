locals {
  # General
  project      = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"
  product      = "${var.prefix}-${var.env_short}"

  # Default Domain Resource Group
  data_rg                     = "${local.project}-data-rg"
  security_rg                 = "${local.project}-security-rg"
  compute_rg                  = "${local.project}-compute-rg"
  cicd_rg                     = "${local.project}-cicd-rg"
  monitor_resource_group_name = "${local.project}-monitoring-rg"

  # 🛜 VNET + Subnets
  network_rg              = "${local.project_core}-network-rg"
  vnet_spoke_data_name    = "${local.project_core}-spoke-data-vnet"
  vnet_spoke_compute_name = "${local.project_core}-spoke-compute-vnet"
  vnet_legacy_core_rg     = "${local.product}-vnet-rg"


  # 🔐 KV
  key_vault_name    = "${local.project}-kv"
  key_vault_rg_name = "${local.project}-security-rg"

  # 📊 Monitoring


  # 🔎 DNS
  dns_zone_name = "${var.env != "prod" ? "${var.env}." : ""}${var.prefix}.pagopa.it"

  # 🍀 Cosmos DB Collection
  cosmos_db = {
    rtp = {
      rtps = {
        index = {
          keys   = ["_id"]
          unique = true
        }
      }
    }
    activation = {
      activations = {
        index = [
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
        index = {
          keys   = ["_id"]
          unique = true
        }
      }
    }
  }
  cosmos_collections = flatten([
    for db_name, db in local.cosmos_db : [
      for coll_name, coll in db : {
        db_name   = db_name
        coll_name = coll_name
        indexes   = flatten([coll.index])
      }
    ]
  ])
}
