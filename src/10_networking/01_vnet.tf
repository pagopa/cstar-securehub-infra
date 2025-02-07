resource "azurerm_resource_group" "rg_vnet" {
  name     = "${local.project}-vnet-rg"
  location = var.location

  tags = var.tags
}

#
# Vnet
#

module "vnet_core" {
  source = "./.terraform/modules/__v3__/virtual_network"

  name                = "${local.project}-vnet"
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  address_space       = var.cidr_core_vnet

  tags = var.tags
}

#
# Subnet
#

# Apim
module "apim_snet" {
  source = "./.terraform/modules/__v3__/subnet"

  name                                      = "${local.project}-apim-snet"
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet_core.name
  address_prefixes                          = var.cidr_subnet_apim
  private_endpoint_network_policies_enabled = true
  service_endpoints                         = ["Microsoft.Web"]
}

# App gateway
module "appgateway_snet" {
  source = "./.terraform/modules/__v3__/subnet"

  name                                      = "${local.project}-appgateway-snet"
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet_core.name
  address_prefixes                          = var.cidr_subnet_appgateway
  private_endpoint_network_policies_enabled = true
}

# Azdoa
module "azdoa_snet" {
  source = "./.terraform/modules/__v3__/subnet"
  count  = var.enable_azdoa ? 1 : 0

  name                                      = "${local.project}-azdoa-snet"
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet_core.name
  address_prefixes                          = var.cidr_subnet_azdoa
  private_endpoint_network_policies_enabled = true
}

# Private Endpoint
# In other ENV subnet is created in specific domains
module "prv_endpoint_snet" {
  source = "./.terraform/modules/__v3__/subnet"
  count  = var.env_short == "d" ? 1 : 0

  name                                      = "${local.project}-private-endpoint-snet"
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet_core.name
  address_prefixes                          = var.cidr_subnet_prv_endpoint
  private_endpoint_network_policies_enabled = true
  service_endpoints                         = ["Microsoft.AzureCosmosDB"]
}

#
# NSG
#

# APIM
resource "azurerm_network_security_group" "nsg_apim" {
  name                = "${local.project}-apim-nsg"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location

  security_rule {
    name                       = "managementapim"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3443"
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "snet_nsg" {
  subnet_id                 = module.apim_snet.id
  network_security_group_id = azurerm_network_security_group.nsg_apim.id
}
