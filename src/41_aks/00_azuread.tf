# Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.product}-adgroup-admin"
}

data "azuread_group" "adgroup_developers" {
  display_name = "${local.product}-adgroup-developers"
}

data "azuread_group" "adgroup_externals" {
  display_name = "${local.product}-adgroup-externals"
}

data "azuread_group" "adgroup_security" {
  display_name = "${local.product}-adgroup-security"
}

data "azuread_group" "adgroup_operations" {
  display_name = "${local.product}-adgroup-operations"
}

data "azuread_group" "adgroup_technical_project_managers" {
  display_name = "${local.product}-adgroup-technical-project-managers"
}

data "azuread_group" "adgroup_eng_spa_externals" {
  count        = contains(["d", "u"], var.env_short) ? 1 : 0
  display_name = "${local.product}-adgroup-eng-spa-externals"
}
