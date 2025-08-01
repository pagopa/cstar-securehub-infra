# Data per Grafana Managed
data "azurerm_dashboard_grafana" "grafana_managed" {
  name                = local.grafana_name
  resource_group_name = local.monitoring_rg_name
}

# Data per Log Analytics Workspace
data "azurerm_log_analytics_workspace" "law" {
  name                = local.law_name
  resource_group_name = local.monitoring_rg_name
}

data "azurerm_log_analytics_workspace" "law_core" {
  name                = local.law_name_core
  resource_group_name = local.law_name_core_rg
}

data "azurerm_log_analytics_workspace" "law_core_itn" {
  name                = local.law_name_core_itn
  resource_group_name = local.law_name_core_itn_rg
}

data "azurerm_log_analytics_workspace" "law_srtp" {
  name                = local.law_name_srtp
  resource_group_name = local.law_name_srtp_rg
}

data "azurerm_log_analytics_workspace" "law_mcshared" {
  name                = local.law_name_mcshared
  resource_group_name = local.law_name_mcshared_rg
}


# ---------------------------------------------------------------
# Data per Secret su Key Vault
# ---------------------------------------------------------------
data "azurerm_key_vault" "core" {
  name                = local.kv_core_name
  resource_group_name = local.kv_core_resource_group_name
}

data "azurerm_key_vault_secret" "grafana_service_account_token" {
  name         = "grafana-itn-service-account-token-value"
  key_vault_id = data.azurerm_key_vault.core.id
}


# Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.product}-adgroup-admin"
}

data "azuread_group" "adgroup_developers" {
  display_name = "${local.product}-adgroup-developers"
}

data "azuread_user" "adgroup_cstar_users_developer" {
  for_each  = toset(data.azuread_group.adgroup_developers.members)
  object_id = each.value
}

data "azuread_group" "adgroup_externals" {
  display_name = "${local.product}-adgroup-externals"
}

data "azuread_group" "adgroup_security" {
  display_name = "${local.product}-adgroup-security"
}
