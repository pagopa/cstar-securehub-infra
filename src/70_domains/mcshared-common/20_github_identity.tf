# ------------------------------------------------------------------------------
# Identity for GitHub used for continuous delivery.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "identity_cd" {
  resource_group_name = local.cicd_rg_name
  location            = var.location
  name                = "${local.project}-github-cd-id"
  tags                = module.tag_config.tags
}

# ------------------------------------------------------------------------------
# Federated identity credentials for GitHub repositories.
# ------------------------------------------------------------------------------
resource "azurerm_federated_identity_credential" "identity_credentials_cd" {
  for_each = toset(local.repositories)

  resource_group_name = local.cicd_rg_name
  name                = "${local.project}-github-${each.value}"
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.identity_cd.id
  subject             = "repo:pagopa/${each.value}:environment:${local.project}"
}
