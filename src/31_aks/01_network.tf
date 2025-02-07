module "aks_snet_system" {
  source                                        = "./.terraform/modules/__v3__/subnet"
  name                                          = "${local.project}-aks-system-snet"
  address_prefixes                              = var.aks_cidr_system_subnet
  resource_group_name                           = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name                          = data.azurerm_virtual_network.vnet.name
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies_enabled     = true
}

module "aks_snet_user" {
  source                                        = "./.terraform/modules/__v3__/subnet"
  name                                          = "${local.project}-aks-user-snet"
  address_prefixes                              = var.aks_cidr_user_subnet
  resource_group_name                           = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name                          = data.azurerm_virtual_network.vnet.name
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies_enabled     = true
  service_endpoints                             = ["Microsoft.Storage", "Microsoft.AzureCosmosDB", "Microsoft.EventHub"]
}

#
# DNS private - Records
#

resource "azurerm_private_dns_a_record" "ingress" {
  name                = local.ingress_hostname_prefix
  zone_name           = data.azurerm_private_dns_zone.internal.name
  resource_group_name = local.internal_dns_zone_resource_group_name
  ttl                 = 3600
  records             = [local.ingress_load_balancer_ip]
}
