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

## IDPAY Groups
data "azuread_group" "idpay_adgroup_domain_admin" {
  display_name = "${local.product}-idpay-adgroup-admin"
}

data "azuread_group" "idpay_adgroup_domain_oncall" {
  count = var.env == "prod" ? 1 : 0

  display_name = "${local.product}-idpay-adgroup-oncall"
}

## MDC Groups
data "azuread_group" "mdc_adgroup_domain_admin" {
  display_name = "${local.product}-mdc-adgroup-admin"
}

data "azuread_group" "mdc_adgroup_domain_oncall" {
  count = var.env == "prod" ? 1 : 0

  display_name = "${local.product}-mdc-adgroup-oncall"
}
