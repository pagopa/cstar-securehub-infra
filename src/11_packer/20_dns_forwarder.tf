module "dns_forwarder_image" {
  source = "./.terraform/modules/__v4__/dns_forwarder_vm_image"

  prefix              = local.product
  resource_group_name = azurerm_resource_group.packer_rg.name
  location            = var.location
  image_name          = "${local.project}-dns-forwarder-ubuntu2204-image"
  image_version       = var.dns_forwarder_image_version
  subscription_id     = data.azurerm_subscription.current.subscription_id

  depends_on = [
    azurerm_resource_group.packer_rg,
  ]
}
