locals {
  secure_hub_vnets_peered = {
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
}

#
# ⛓️ Peering to cstar-infrastructure
#
# SECURE-HUB TO CSTAR WEU CORE
module "vnet_secure_hub_to_core_peering" {
  source = "./.terraform/modules/__v4__/virtual_network_peering"

  for_each = local.secure_hub_vnets_peered


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

# SECURE-HUB TO CSTAR WEU AKS
module "vnet_secure_hub_to_aks_peering" {
  source = "./.terraform/modules/__v4__/virtual_network_peering"

  for_each = local.secure_hub_vnets_peered

  # Define source virtual network peering details
  source_resource_group_name       = each.value.resource_group_name
  source_virtual_network_name      = each.value.name
  source_remote_virtual_network_id = each.value.id

  # Define target virtual network peering details
  target_resource_group_name       = data.azurerm_virtual_network.vnet_weu_aks.resource_group_name
  target_virtual_network_name      = data.azurerm_virtual_network.vnet_weu_aks.name
  target_remote_virtual_network_id = data.azurerm_virtual_network.vnet_weu_aks.id
}
