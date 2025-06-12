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

#
# Azure Resource Groups
#
data "azurerm_resource_group" "idpay_security_rg" {
  name = "${local.project}-security-rg"
}

data "azurerm_api_management" "apim" {
  name                = local.apim_name
  resource_group_name = local.apim_resource_group_name
}

data "azurerm_user_assigned_identity" "azdo_managed_identity" {
  name                = local.azdo_managed_identity_name
  resource_group_name = local.azdo_managed_identity_rg_name
}
