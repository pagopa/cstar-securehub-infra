#
# VPN
#
module "vpn_snet" {
  source = "./.terraform/modules/__v3__/subnet"

  name                 = "GatewaySubnet"
  address_prefixes     = var.cidr_vpn_subnet
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet_core.name
  service_endpoints    = []
}

module "vpn" {
  source = "./.terraform/modules/__v3__/vpn_gateway"

  name                = "${local.project}-vpn"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  sku                 = var.vpn_sku
  pip_sku             = var.vpn_pip_sku
  subnet_id           = module.vpn_snet.id

  vpn_client_configuration = [
    {
      address_space         = ["172.16.1.0/24"],
      vpn_client_protocols  = ["OpenVPN"],
      aad_audience          = data.azuread_application.vpn_app.application_id
      aad_issuer            = "https://sts.windows.net/${data.azurerm_subscription.current.tenant_id}/"
      aad_tenant            = "https://login.microsoftonline.com/${data.azurerm_subscription.current.tenant_id}"
      radius_server_address = null
      radius_server_secret  = null
      revoked_certificate   = []
      root_certificate      = []
    }
  ]

  tags = var.tags
}

#
# DNS Forwarder
#

module "dns_forwarder_lb_vmss" {
  source = "./.terraform/modules/__v3__/dns_forwarder_lb_vmss"

  name                 = local.project
  virtual_network_name = module.vnet_core.name
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  location             = var.location
  subscription_id      = data.azurerm_subscription.current.subscription_id
  tenant_id            = data.azurerm_client_config.current.tenant_id
  key_vault_id         = data.azurerm_key_vault.key_vault.id
  source_image_name    = local.dns_forwarder_vm_image_name
  tags                 = var.tags
}