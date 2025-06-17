resource "azurerm_resource_group" "managed_identities_rg" {
  name     = "${local.project}-identity-rg"
  location = var.location
  tags     = module.tag_config.tags
}
