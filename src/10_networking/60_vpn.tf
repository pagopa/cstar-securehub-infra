## VPN subnet
module "vpn_snet" {
  source = "./.terraform/modules/__v4__/subnet"

  name                 = "GatewaySubnet"
  address_prefixes     = var.cidr_subnet_vpn
  virtual_network_name = module.vnet_core_hub.name
  resource_group_name  = module.vnet_core_hub.resource_group_name
  service_endpoints    = []
}

data "azuread_application" "vpn_app" {
  display_name = "${local.product}-app-vpn"
}

module "vpn" {
  source = "./.terraform/modules/__v4__/vpn_gateway"
  # source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//vpn_gateway?ref=fix-vpn-pip-allocation-method"

  name                = "${local.project}-vpn"
  location            = var.location
  resource_group_name = module.vnet_core_hub.resource_group_name

  sku       = var.vpn_sku
  pip_sku   = var.vpn_pip_sku
  subnet_id = module.vpn_snet.id

  vpn_client_configuration = [
    {
      address_space         = ["172.16.1.0/24"],
      vpn_client_protocols  = ["OpenVPN"],
      aad_audience          = data.azuread_application.vpn_app.client_id
      aad_issuer            = "https://sts.windows.net/${data.azurerm_subscription.current.tenant_id}/"
      aad_tenant            = "https://login.microsoftonline.com/${data.azurerm_subscription.current.tenant_id}"
      radius_server_address = null
      radius_server_secret  = null
      revoked_certificate   = []
      root_certificate      = []
    }
  ]

  tags = module.tag_config.tags
}

# Dns Forwarder module

module "subnet_dns_forwarder_lb" {
  source = "./.terraform/modules/__v4__/subnet"

  name                 = "${local.project}-dns-forwarder-lb"
  address_prefixes     = var.cidr_subnet_dnsforwarder_lb
  virtual_network_name = module.vnet_core_hub.name
  resource_group_name  = module.vnet_core_hub.resource_group_name
}

module "subnet_dns_forwarder_vmss" {
  source = "./.terraform/modules/__v4__/subnet"

  name                 = "${local.project}-dns-forwarder-vmss"
  address_prefixes     = var.cidr_subnet_dnsforwarder_vmss
  virtual_network_name = module.vnet_core_hub.name
  resource_group_name  = module.vnet_core_hub.resource_group_name
}

module "dns_forwarder_lb_vmss" {
  source = "./.terraform/modules/__v4__/dns_forwarder_lb_vmss"
  # source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//dns_forwarder_lb_vmss?ref=PAYMCLOUD-399-v-4-vpn-update"

  name                 = local.project
  virtual_network_name = module.vnet_core_hub.name
  resource_group_name  = azurerm_resource_group.rg_network.name

  static_address_lb = cidrhost(var.cidr_subnet_dnsforwarder_lb[0], 4)
  subnet_lb_id      = module.subnet_dns_forwarder_lb.id
  subnet_vmss_id    = module.subnet_dns_forwarder_vmss.id

  location          = var.location
  subscription_id   = data.azurerm_subscription.current.subscription_id
  key_vault_id      = data.azurerm_key_vault.kv_core.id
  tenant_id         = data.azurerm_client_config.current.id
  source_image_name = "cstar-${var.env_short}-itn-packer-dns-forwarder-ubuntu2204-image-${var.dns_forwarder_vmss_image_version}"

  tags = module.tag_config.tags
}
