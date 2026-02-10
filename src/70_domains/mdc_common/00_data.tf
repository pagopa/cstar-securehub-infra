# 🔑 Azure AD
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

data "azuread_group" "adgroup_mdc_admin" {
  display_name = "${local.project_entra}-adgroup-admin"
}

data "azuread_group" "adgroup_mdc_developers" {
  display_name = "${local.project_entra}-adgroup-developers"
}

data "azuread_group" "adgroup_mdc_externals" {
  display_name = "${local.project_entra}-adgroup-externals"
}

data "azuread_group" "adgroup_mdc_project_managers" {
  count        = var.env == "prod" ? 1 : 0
  display_name = "${local.project_entra}-adgroup-project-managers"
}

data "azuread_group" "adgroup_mdc_oncall" {
  count        = var.env == "prod" ? 1 : 0
  display_name = "${local.project_entra}-adgroup-oncall"
}

#
# Azure Resource Groups
#
data "azurerm_resource_group" "mdc_data_rg" {
  name = "${local.project}-data-rg"
}

data "azurerm_resource_group" "mdc_monitoring_rg" {
  name = "${local.project}-monitoring-rg"
}

# 🔒 KV
data "azurerm_key_vault" "kv_domain" {
  name                = local.kv_domain_name
  resource_group_name = local.kv_domain_rg_name
}

# 📊 Monitoring
data "azurerm_resource_group" "monitor_rg" {
  name = local.monitor_resource_group_name
}

data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = local.log_analytics_workspace_name
  resource_group_name = local.monitor_resource_group_name
}

data "azurerm_application_insights" "application_insights" {
  name                = local.monitor_appinsights_name
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
}

data "azurerm_monitor_action_group" "slack" {
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  name                = local.monitor_action_group_slack
}

data "azurerm_monitor_action_group" "email" {
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  name                = local.monitor_action_group_email
}

# 🔎 DNS
data "azurerm_private_dns_zone" "internal" {
  name                = local.internal_dns_zone_name
  resource_group_name = local.internal_dns_zone_resource_group_name
}

data "azurerm_private_dns_zone" "cosmos" {
  name                = local.cosmos_dns_zone_name
  resource_group_name = local.cosmos_dns_zone_resource_group_name
}

data "azurerm_private_dns_zone" "eventhub" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = local.vnet_legacy_resource_group_name
}

data "azurerm_private_dns_zone" "privatelink_redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = local.vnet_legacy_resource_group_name
}

# 🐳 Kubernetes Cluster
data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = local.aks_resource_group_name
}

### ARGO
data "azurerm_key_vault_secret" "argocd_admin_username" {
  name         = "argocd-admin-username"
  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

data "azurerm_key_vault_secret" "argocd_admin_password" {
  name         = "argocd-admin-password"
  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

# NatGateway
data "azurerm_nat_gateway" "compute_nat_gateway" {
  name                = "${local.project_core}-compute-natgw"
  resource_group_name = local.vnet_network_rg
}
