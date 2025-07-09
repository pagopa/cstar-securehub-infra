data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}


data "github_team" "admin" {
  slug = "swc-mil-team-admin"
}

data "azurerm_user_assigned_identity" "cd_client_identity" {
  name                = "${local.project}-github-cd-id"
  resource_group_name = local.cicd_rg_name
}
