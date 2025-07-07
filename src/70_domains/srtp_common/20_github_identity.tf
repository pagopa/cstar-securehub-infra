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
  subject             = "repo:pagopa/${each.value}:environment:${var.location_short}-${var.env}"
}

resource "azurerm_role_assignment" "identity_role_assignment_cd" {
  for_each = toset(local.default_resourge_group_names)

  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${each.key}"
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.identity_cd.principal_id
}

resource "azurerm_role_assignment" "identity_role_assignment_cd_state_storaga_account" {

  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/terraform-state-rg/providers/Microsoft.Storage/storageAccounts/tfapp${var.env}cstar"
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = azurerm_user_assigned_identity.identity_cd.principal_id
}
