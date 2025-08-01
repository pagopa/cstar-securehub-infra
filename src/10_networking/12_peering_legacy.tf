locals {
  legacy_vnets = {
    frontend = {
      name                = data.azurerm_virtual_network.vnet_weu_core.name
      id                  = data.azurerm_virtual_network.vnet_weu_core.id
      resource_group_name = data.azurerm_virtual_network.vnet_weu_core.resource_group_name
    }
    apim = {
      name                = data.azurerm_virtual_network.vnet_weu_integration.name
      id                  = data.azurerm_virtual_network.vnet_weu_integration.id
      resource_group_name = data.azurerm_virtual_network.vnet_weu_integration.resource_group_name
    }
    aks_weu = {
      name                = data.azurerm_virtual_network.vnet_weu_aks.name
      id                  = data.azurerm_virtual_network.vnet_weu_aks.id
      resource_group_name = data.azurerm_virtual_network.vnet_weu_aks.resource_group_name
    }
  }

  # Collect vnet spoke
  all_hub_to_legacy_peerings = {
    for k, v in local.legacy_vnets :
    k => v
  }
}

#
# ⛓️ Peering to legacy cstar-infrastructure (+VPN)
#
# Core HUB Vnet TO All legacy VNETs
module "vnet_secure_hub_to_legacy_peerings" {
  source = "./.terraform/modules/__v4__/virtual_network_peering"

  for_each = local.all_hub_to_legacy_peerings

  # Define source virtual network peering details
  source_resource_group_name       = azurerm_resource_group.rg_network.name
  source_virtual_network_name      = module.vnet_core_hub.name
  source_remote_virtual_network_id = module.vnet_core_hub.id
  source_allow_gateway_transit     = true

  target_resource_group_name       = each.value.resource_group_name
  target_virtual_network_name      = each.value.name
  target_remote_virtual_network_id = each.value.id
  target_use_remote_gateways       = true
}

#
# ⛓️ Peering from secure spoke compute to all legacy VNETs
#
module "vnet_secure_spoke_compute_to_legacy_peerings" {
  source = "./.terraform/modules/__v4__/virtual_network_peering"

  for_each = local.all_hub_to_legacy_peerings

  # Define source virtual network peering details
  source_resource_group_name       = azurerm_resource_group.rg_network.name
  source_virtual_network_name      = module.vnet_spoke_compute.name
  source_remote_virtual_network_id = module.vnet_spoke_compute.id
  source_allow_gateway_transit     = true

  target_resource_group_name       = each.value.resource_group_name
  target_virtual_network_name      = each.value.name
  target_remote_virtual_network_id = each.value.id
  target_use_remote_gateways       = false
}

#
# ⛓️ Peering from secure spoke data to all legacy VNETs
#
module "vnet_secure_spoke_data_to_vnet_integration" {
  source = "./.terraform/modules/__v4__/virtual_network_peering"

  for_each = local.all_hub_to_legacy_peerings

  # Define source virtual network peering details
  source_resource_group_name       = azurerm_resource_group.rg_network.name
  source_virtual_network_name      = module.vnet_spoke_data.name
  source_remote_virtual_network_id = module.vnet_spoke_data.id
  source_allow_gateway_transit     = false

  target_resource_group_name       = each.value.resource_group_name
  target_virtual_network_name      = each.value.name
  target_remote_virtual_network_id = each.value.id
  target_use_remote_gateways       = false
}
