data "azurerm_resource_group" "platform_data" {
  name = local.platform_data_rg_name
}

#------------------------------------------------
# Azure Kubernetes Service
#------------------------------------------------
data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = local.aks_resource_group_name
}


#-----------------------------------------------
# Key Vault
#-----------------------------------------------
data "azurerm_key_vault" "key_vault_core" {
  name                = local.kv_core_name
  resource_group_name = local.kv_core_resource_group_name
}

#-----------------------------------------------
# Network
#-----------------------------------------------
data "azurerm_virtual_network" "data_vnet" {
  name                = local.vnet_data_name
  resource_group_name = local.vnet_network_rg_name
}

data "azurerm_subnet" "platform_subnet" {
  name                 = local.subnet_postgres_name
  virtual_network_name = data.azurerm_virtual_network.data_vnet.name
  resource_group_name  = data.azurerm_virtual_network.data_vnet.resource_group_name
}

data "azurerm_private_dns_zone" "postgres_flexible_privatelink" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = local.legacy_vnet_core_rg_name
}

data "azurerm_private_dns_zone" "internal" {
  name                = local.dns_private_internal_name
  resource_group_name = local.dns_private_internal_rg_name
}

#-----------------------------------------------
# Monitoring
#-----------------------------------------------
data "azurerm_resource_group" "monitoring_rg" {
  name = local.monitoring_rg_name
}

data "azurerm_application_insights" "app_insights" {
  name                = local.app_insights_name
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name
}

data "azurerm_log_analytics_workspace" "logs_workspace" {
  name                = local.law_name
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name
}


### Azure AD
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
