# Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.product}-adgroup-admin"
}

data "azuread_group" "ad_groups" {
  for_each = local.ad_groups

  display_name = each.value.display_name
}
