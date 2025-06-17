resource "azurerm_resource_group" "azdo" {
  name     = "${local.product_location}-core-azdo-rg"
  location = var.location

  tags = module.tag_config.tags
}

module "azdoa_custom_image" {
  source = "./.terraform/modules/__v4__/azure_devops_agent_custom_image"

  prefix              = var.prefix
  resource_group_name = azurerm_resource_group.azdo.name
  location            = var.location
  image_name          = "${local.project}-azdo-agent-ubuntu2204-image"
  image_version       = var.azdo_agent_image_version
  subscription_id     = data.azurerm_subscription.current.subscription_id

  depends_on = [
    azurerm_resource_group.azdo,
  ]
}
