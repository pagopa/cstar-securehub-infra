data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

# Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.product}-adgroup-admin"
}

#---------------------------------------------------------------------------
# Domain Groups
#---------------------------------------------------------------------------
data "azuread_group" "srtp_adgroup_admin" {
  display_name = "${local.project_entra}-adgroup-admin"
}

data "azuread_group" "srtp_adgroup_developers" {
  display_name = "${local.project_entra}-adgroup-developers"
}

data "azuread_group" "srtp_adgroup_externals" {
  display_name = "${local.project_entra}-adgroup-externals"
}


#
# Azure Resource Groups
#
data "azurerm_resource_group" "security_rg" {
  name = "${local.project}-security-rg"
}

data "azurerm_user_assigned_identity" "iac_federated_azdo" {
  for_each = toset(concat(
    local.azdo_iac_managed_identities_read,
    local.azdo_iac_managed_identities_write
  ))

  name                = each.key
  resource_group_name = local.azdo_managed_identity_rg_name
}

data "azurerm_user_assigned_identity" "subscription_service_connection" {
  name                = "${upper(var.env)}-${upper(var.prefix)}"
  resource_group_name = local.azdo_managed_identity_rg_name
}
