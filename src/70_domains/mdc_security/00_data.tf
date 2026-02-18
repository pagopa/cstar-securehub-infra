# Azure AD groups used for key vault access policies
data "azuread_group" "adgroup_admin" {
  display_name = "${local.product}-adgroup-admin"
}

# Azure domain AD
data "azuread_group" "adgroup_domain_admin" {
  display_name = "${local.product_domain}-adgroup-admin"
}

data "azuread_group" "adgroup_domain_developers" {
  display_name = "${local.product_domain}-adgroup-developers"
}

data "azuread_group" "adgroup_domain_externals" {
  display_name = "${local.product_domain}-adgroup-externals"
}

#
# Azure Resource Groups
#
data "azurerm_resource_group" "idpay_security_rg" {
  name = "${local.project}-security-rg"
}

#
# AZDO
#
data "azurerm_user_assigned_identity" "iac_federated_azdo" {
  for_each = toset(concat(local.azdo_iac_managed_identities_read, local.azdo_iac_managed_identities_write))

  name                = each.key
  resource_group_name = local.azdo_managed_identity_rg_name
}
