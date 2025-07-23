#
# 🌐 Network
#
data "azurerm_private_dns_zone" "internal" {
  name                = local.dns_private_internal_name
  resource_group_name = local.dns_private_internal_rg_name
}

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
