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
# ⛓️ Peering to HUB cstar-securehub-infra
#
# HUB cstar-securehub vs ALL SPOKEs
module "vnet_secure_hub_to_spoke_peering" {
  source = "./.terraform/modules/__v4__/virtual_network_peering"

  for_each = local.all_vnets_peering_to_hub


  # Define source virtual network peering details
  source_resource_group_name       = each.value.resource_group_name
  source_virtual_network_name      = each.value.name
  source_remote_virtual_network_id = each.value.id

  # Define target virtual network peering details
  target_resource_group_name       = azurerm_resource_group.rg_network.name
  target_virtual_network_name      = module.vnet_core_hub.name
  target_remote_virtual_network_id = module.vnet_core_hub.id
}

#
# ⛓️ Peering to cstar-infrastructure
#
# ALL SECURE-HUB Vnets TO CSTAR WEU CORE
module "vnet_secure_hub_to_core_peering" {
  source = "./.terraform/modules/__v4__/virtual_network_peering"

  for_each = local.secure_hub_vnets


  # Define source virtual network peering details
  source_resource_group_name       = each.value.resource_group_name
  source_virtual_network_name      = each.value.name
  source_remote_virtual_network_id = each.value.id
  source_use_remote_gateways       = true

  # Define target virtual network peering details
  target_resource_group_name       = data.azurerm_virtual_network.vnet_weu_core.resource_group_name
  target_virtual_network_name      = data.azurerm_virtual_network.vnet_weu_core.name
  target_remote_virtual_network_id = data.azurerm_virtual_network.vnet_weu_core.id
  target_allow_gateway_transit     = true
}

# # ALL SECURE-HUB TO CSTAR WEU AKS
# module "vnet_secure_hub_to_aks_peering" {
#   source = "./.terraform/modules/__v4__/virtual_network_peering"
# 
#   for_each = local.secure_hub_vnets
#
#   # Define source virtual network peering details
#   source_resource_group_name       = each.value.resource_group_name
#   source_virtual_network_name      = each.value.name
#   source_remote_virtual_network_id = each.value.id
#
#   # Define target virtual network peering details
#   target_resource_group_name       = data.azurerm_virtual_network.vnet_weu_aks.resource_group_name
#   target_virtual_network_name      = data.azurerm_virtual_network.vnet_weu_aks.name
#   target_remote_virtual_network_id = data.azurerm_virtual_network.vnet_weu_aks.id
# }

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
