locals {
  secure_hub_vnets = {
    hub = {
      name                = module.vnet_core_hub.name
      id                  = module.vnet_core_hub.id
      resource_group_name = azurerm_resource_group.rg_network.name
    }
    platform = {
      name                = module.vnet_spoke_platform_core.name
      id                  = module.vnet_spoke_platform_core.id
      resource_group_name = azurerm_resource_group.rg_network.name
    }
    data = {
      name                = module.vnet_spoke_data.name
      id                  = module.vnet_spoke_data.id
      resource_group_name = azurerm_resource_group.rg_network.name
    }
    compute = {
      name                = module.vnet_spoke_compute.name
      id                  = module.vnet_spoke_compute.id
      resource_group_name = azurerm_resource_group.rg_network.name
    }
    security = {
      name                = module.vnet_spoke_security.name
      id                  = module.vnet_spoke_security.id
      resource_group_name = azurerm_resource_group.rg_network.name
    }
  }
  # Collect vnet spoke
  all_vnets_peering_to_hub = {
    for k, v in local.secure_hub_vnets :
    k => v if k != "hub"
  }

  # vnet core hub is not included in the peering map because already setup
  all_vnets_peering_to_spoke_compute = {
    for k, v in local.secure_hub_vnets :
    k => v if k != "hub" && k != "compute"
  }
}

#
# ⛓️ Peering HUB cstar-securehub-infra
#
# HUB cstar-securehub vs ALL SPOKEs (with VPN configuration)
module "vnet_secure_hub_to_spoke_peering" {
  source = "./.terraform/modules/__v4__/virtual_network_peering"

  for_each = local.all_vnets_peering_to_hub

  # Define target virtual network peering details
  source_resource_group_name       = azurerm_resource_group.rg_network.name
  source_virtual_network_name      = module.vnet_core_hub.name
  source_remote_virtual_network_id = module.vnet_core_hub.id
  source_allow_gateway_transit = true

  # Define source virtual network peering details
  target_resource_group_name       = each.value.resource_group_name
  target_virtual_network_name      = each.value.name
  target_remote_virtual_network_id = each.value.id
  target_use_remote_gateways = true
}

#
# Spoke COMPUTE Peerings
#
module "vnet_spoke_compute_peerings" {
  source = "./.terraform/modules/__v4__/virtual_network_peering"

  for_each = local.all_vnets_peering_to_spoke_compute

  # Define source virtual network peering details
  source_resource_group_name       = each.value.resource_group_name
  source_virtual_network_name      = each.value.name
  source_remote_virtual_network_id = each.value.id

  # Define target virtual network peering details
  target_resource_group_name       = module.vnet_spoke_compute.resource_group_name
  target_virtual_network_name      = module.vnet_spoke_compute.name
  target_remote_virtual_network_id = module.vnet_spoke_compute.id
}
