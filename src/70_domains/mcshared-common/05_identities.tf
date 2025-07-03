# ------------------------------------------------------------------------------
# Identity for auth microservice.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "auth" {
  resource_group_name = local.security_rg_name
  location            = var.location
  name                = "${local.project}-auth-id"

  tags = module.tag_config.tags
}
