resource "azurerm_resource_group" "packer_rg" {
  name     = "${local.project}-rg"
  location = var.location

  tags = var.tags
}
