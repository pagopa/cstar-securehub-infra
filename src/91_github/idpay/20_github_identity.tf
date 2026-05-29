# ------------------------------------------------------------------------------
# Tags configuration.
# ------------------------------------------------------------------------------
module "tag_config" {
  source      = "../../tag_config"
  domain      = var.domain
  environment = var.env
}

# ------------------------------------------------------------------------------
# Identity for GitHub.
# ------------------------------------------------------------------------------
resource "azurerm_resource_group" "github" {
  name     = "${local.project}-github-rg"
  location = var.location
  tags     = module.tag_config.tags
}

resource "azurerm_user_assigned_identity" "github" {
  resource_group_name = azurerm_resource_group.github.name
  location            = var.location
  name                = "${local.project}-github-id"
  tags                = module.tag_config.tags
}

# ------------------------------------------------------------------------------
# Federated identity credentials for GitHub repositories.
# ------------------------------------------------------------------------------
resource "azurerm_federated_identity_credential" "github" {
  for_each = local.repositories_with_federated_identity

  name      = "${local.project}-github-${each.value}"
  audience  = ["api://AzureADTokenExchange"]
  issuer    = "https://token.actions.githubusercontent.com"
  parent_id = azurerm_user_assigned_identity.github.id
  subject   = "repo:pagopa/${each.value}:environment:${var.location_short}-${var.env}"
}

# ------------------------------------------------------------------------------
# Role assignment for GitHub Identity.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "github_deployer_role" {
  for_each = toset(local.github_deployer_scopes)

  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${each.key}"
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.github.principal_id
}
