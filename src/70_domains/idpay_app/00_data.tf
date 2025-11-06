#
# Azure Kubernetes Service
#
data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = local.aks_resource_group_name
}

#
# EventHub
#
data "azurerm_eventhub_namespace" "eventhub_00" {
  name                = local.eventhub_00_namespace_name
  resource_group_name = local.data_rg_name
}

#
# Monitor
#
data "azurerm_resource_group" "monitoring_rg" {
  name = local.monitoring_rg_name
}

data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${local.project}-law"
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name
}

data "azurerm_resource_group" "core_monitoring_rg" {
  name = "cstar-${var.env_short}-itn-core-monitor-rg"
}

data "azurerm_log_analytics_workspace" "core_log_analytics_workspace" {
  name                = "cstar-${var.env_short}-itn-core-appinsights"
  resource_group_name = data.azurerm_resource_group.core_monitoring_rg.name
}

data "azurerm_application_insights" "core_app_insights" {
  name                = data.azurerm_log_analytics_workspace.core_log_analytics_workspace.name
  resource_group_name = data.azurerm_resource_group.core_monitoring_rg.name
}

data "azurerm_monitor_action_group" "alerts_email" {
  count               = contains(["p", "u"], var.env_short) ? 1 : 0
  name                = local.monitor_alert_email_group_name
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name
}

data "azurerm_monitor_action_group" "alerts_opsgenie" {
  count               = var.env_short == "p" ? 1 : 0
  name                = local.monitor_alert_opsgenie_group_name
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name
}


#------------------------------------------------------------------
# Azure AD
#------------------------------------------------------------------
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

data "azuread_group" "adgroup_security" {
  display_name = "${local.product}-adgroup-security"
}
