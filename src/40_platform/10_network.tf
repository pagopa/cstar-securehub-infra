#
# Network
#
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

#
# Private endpoints
#
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

# peer to pagopa integration cstar vnet
resource "azurerm_virtual_network_peering" "peer_spoke_compute_to_pagopa_integration_cstar" {
  name                      = "${data.azurerm_virtual_network.vnet_compute.name}-to-${local.pagopa_cstar_integration_vnet_name}"
  resource_group_name       = data.azurerm_virtual_network.vnet_compute.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.vnet_compute.name
  remote_virtual_network_id = "/subscriptions/${data.azurerm_key_vault_secret.pagopa_subscritpion_id.value}/resourceGroups/${local.pagopa_cstar_integration_vnet_rg_name}/providers/Microsoft.Network/virtualNetworks/${local.pagopa_cstar_integration_vnet_name}"
}


resource "azurerm_private_dns_a_record" "pagopa_eventhub_private_dns_record" {
  name                = "pagopa-${var.env_short}-itn-gps-rtp-integration-evh"
  records             = [data.azurerm_key_vault_secret.pagopa_rtp_eventhub_pip.value]
  resource_group_name = data.azurerm_private_dns_zone.privatelink_servicebus_windows_net.resource_group_name
  ttl                 = 300
  zone_name           = data.azurerm_private_dns_zone.privatelink_servicebus_windows_net.name
}
