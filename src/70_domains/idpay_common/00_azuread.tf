### Azure AD Generic Groups
data "azuread_group" "adgroup_admin" {
  display_name = "${local.product}-adgroup-admin"
}

data "azuread_group" "adgroup_developers" {
  display_name = "${local.product}-adgroup-developers"
}

data "azuread_group" "adgroup_externals" {
  display_name = "${local.product}-adgroup-externals"
}

#---------------------------------------------------------------------------
# Idpay Groups
#---------------------------------------------------------------------------
data "azuread_group" "adgroup_idpay_admin" {
  display_name = "${local.project_entra}-adgroup-admin"
}

data "azuread_group" "adgroup_idpay_developers" {
  display_name = "${local.project_entra}-adgroup-developers"
}

data "azuread_group" "adgroup_idpay_externals" {
  display_name = "${local.project_entra}-adgroup-externals"
}

data "azuread_group" "adgroup_idpay_project_managers" {
  count = var.env == "prod" ? 1 : 0
  display_name = "${local.project_entra}-adgroup-project-managers"
}

data "azuread_group" "adgroup_idpay_oncall" {
  count = var.env == "prod" ? 1 : 0
  display_name = "${local.project_entra}-adgroup-oncall"
}

