#----------------------------------------------------------------
# Network
#----------------------------------------------------------------
module "synthetic_snet" {
  source = "./.terraform/modules/__v4__/subnet"
  # source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//subnet?ref=v1.20.0"

  name                 = "${local.project}-synthetic-snet"
  resource_group_name  = data.azurerm_virtual_network.vnet_hub.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet_hub.name
  address_prefixes     = var.cidr_subnet_synthetic_cae

  delegation = {
    name = "Microsoft.App/environments"
    service_delegation = {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

module "github_cae_snet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"

  # General
  product_name        = var.prefix
  env                 = var.env
  resource_group_name = local.vnet_rg_name

  # Network
  name = "${local.project}-github-cae-snet"

  # Set to the spoke compute VNet because it is the only one with peering to pagoPA integration VNet
  virtual_network_name = local.vnet_core_compute_name

  # IDH Resources
  idh_resource_tier = "container_app_environment_27"
}

#----------------------------------------------------------------
# Subnets Private endpoints
#----------------------------------------------------------------
module "storage_private_endpoint_snet" {
  source = "./.terraform/modules/__v4__/subnet"
  # source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//subnet?ref=v1.20.0"

  resource_group_name  = data.azurerm_virtual_network.vnet_hub.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet_hub.name

  name             = "${local.project}-storage-private-endpoint-snet"
  address_prefixes = var.cidr_subnet_storage_private_endpoints

  service_endpoints = [
    "Microsoft.Storage",
  ]
}

module "container_app_private_endpoint_snet" {
  source = "./.terraform/modules/__v4__/subnet"
  # source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//subnet?ref=v1.20.0"

  resource_group_name  = data.azurerm_virtual_network.vnet_hub.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet_hub.name

  name             = "${local.project}-container-app-private-endpoint-snet"
  address_prefixes = var.cidr_subnet_container_app_private_endpoints
}

module "adf_snet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"

  # General
  product_name        = var.prefix
  env                 = var.env
  resource_group_name = local.vnet_rg_name

  name = "${local.project}-adf-snet"

  virtual_network_name = local.vnet_core_data_name

  # IDH Resources
  idh_resource_tier = "private_endpoint"
}

module "data_postgres_flexible_snet" {
  source               = "./.terraform/modules/__v4__/IDH/subnet"
  name                 = "${local.project}-postgres-snet"
  resource_group_name  = data.azurerm_virtual_network.vnet_data.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet_data.name
  service_endpoints    = ["Microsoft.Storage"]

  idh_resource_tier = "postgres_flexible"
  product_name      = var.prefix
  env               = var.env
}

#----------------------------------------------------------------
# Peer from compute vs pagopa integration cstar vnet
#----------------------------------------------------------------
resource "azurerm_virtual_network_peering" "peer_spoke_compute_to_pagopa_integration_cstar" {
  name                      = "${data.azurerm_virtual_network.vnet_compute.name}-to-${local.pagopa_cstar_integration_vnet_name}"
  resource_group_name       = data.azurerm_virtual_network.vnet_compute.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.vnet_compute.name
  remote_virtual_network_id = "/subscriptions/${data.azurerm_key_vault_secret.pagopa_subscritpion_id.value}/resourceGroups/${local.pagopa_cstar_integration_vnet_rg_name}/providers/Microsoft.Network/virtualNetworks/${local.pagopa_cstar_integration_vnet_name}"
}

#----------------------------------------------------------------
# Private DNS
#----------------------------------------------------------------
resource "azurerm_private_dns_a_record" "pagopa_eventhub_private_dns_record" {
  name                = "pagopa-${var.env_short}-itn-gps-rtp-integration-evh"
  records             = [data.azurerm_key_vault_secret.pagopa_rtp_eventhub_pip.value]
  resource_group_name = data.azurerm_private_dns_zone.privatelink_servicebus_windows_net.resource_group_name
  ttl                 = 300
  zone_name           = data.azurerm_private_dns_zone.privatelink_servicebus_windows_net.name
}
