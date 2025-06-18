locals {
  # ⚠️ This is very important when creating a new subnet for a node pool.
  #    The subnet ID must be added below. This list will be included in the NAT gateway for AKS.
  #    If this step is skipped, the new nodes will never come up.
  #    ref: src/31_aks/01_natgateway.tf:22
  nat_node_pool_subnet_list = toset([
    module.aks_snet.id,
    module.aks_user_snet.id
  ])
}

module "aks_snet" {
  source = "./.terraform/modules/__v4__/subnet"

  name                              = "${local.project}-aks-snet"
  address_prefixes                  = var.aks_cidr_subnet
  resource_group_name               = data.azurerm_virtual_network.vnet_compute_spoke.resource_group_name
  virtual_network_name              = data.azurerm_virtual_network.vnet_compute_spoke.name
  private_endpoint_network_policies = var.subnet_private_endpoint_network_policies_enabled
  service_endpoints = [
    "Microsoft.AzureCosmosDB",
    "Microsoft.EventHub",
    "Microsoft.Storage",
    "Microsoft.ServiceBus"
  ]
}

module "aks_user_snet" {
  source                            = "./.terraform/modules/__v4__/subnet"
  name                              = "${local.project}-aks-user-snet"
  address_prefixes                  = var.aks_cidr_subnet_user
  resource_group_name               = data.azurerm_virtual_network.vnet_compute_spoke.resource_group_name
  virtual_network_name              = data.azurerm_virtual_network.vnet_compute_spoke.name
  private_endpoint_network_policies = var.subnet_private_endpoint_network_policies_enabled
  service_endpoints = [
    "Microsoft.AzureCosmosDB",
    "Microsoft.EventHub",
    "Microsoft.Storage",
    "Microsoft.ServiceBus"
  ]
}

# 🔎 DNS
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_aks" {
  for_each = var.aks_private_cluster_is_enabled ? { for i in toset([data.azurerm_virtual_network.vnet_hub]) : i.name => i } : {}

  name                  = each.value.name
  private_dns_zone_name = module.aks.managed_private_dns_zone_name
  resource_group_name   = module.aks.managed_resource_group_name
  virtual_network_id    = each.value.id
}
