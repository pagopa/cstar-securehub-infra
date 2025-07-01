# ------------------------------------------------------------------------------
# Identity for rtp-activator microservice.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "activator" {
  resource_group_name = data.azurerm_resource_group.identities_rg.name
  location            = data.azurerm_resource_group.identities_rg.location
  name                = "${local.project}-activator-id"
  tags                = var.tags
}

# ------------------------------------------------------------------------------
# Identity for rtp-sender microservice.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "sender" {
  resource_group_name = data.azurerm_resource_group.identities_rg.name
  location            = data.azurerm_resource_group.identities_rg.location
  name                = "${local.project}-sender-id"
  tags                = var.tags
}
