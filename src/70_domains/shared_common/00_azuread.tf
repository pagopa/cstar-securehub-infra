### Azure AD Generic Groups
data "azuread_group" "adgroup_admin" {
  display_name = "${local.product}-adgroup-admin"
}
