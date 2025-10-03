data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

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
data "azurerm_resource_group" "security_rg" {
  name = "${local.project}-security-rg"
}
