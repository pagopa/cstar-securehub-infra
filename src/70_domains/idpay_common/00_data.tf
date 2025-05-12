#
# Azure Resource Groups
#
data "azurerm_resource_group" "idpay_data_rg" {
  name = "${local.project}-data-rg"
}

#
# 🌐 Network
#
data "azurerm_virtual_network" "vnet_spoke_data" {
  name                = local.vnet_spoke_data_name
  resource_group_name = local.vnet_spoke_data_rg_name
}

data azurerm_dns_zone "public_cstar" {
  name                = local.public_dns_zone_name
  resource_group_name = local.vnet_core_rg_name
}

#
# Private DNS Zones
#
# Cosmos MongoDB private dns zone
data "azurerm_private_dns_zone" "cosmos_mongo" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = local.vnet_core_rg_name
}

# Eventhub private dns zone
data "azurerm_private_dns_zone" "eventhub" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = local.vnet_core_rg_name
}

# Redis private dns zone
data "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = local.vnet_core_rg_name
}

data "azurerm_private_dns_zone" "servicebus" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = local.vnet_core_rg_name
}

data "azurerm_private_dns_zone" "storage_account_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = local.vnet_core_rg_name
}

data "azurerm_private_dns_zone" "storage_account_table" {
  name                = "privatelink.table.core.windows.net"
  resource_group_name = local.vnet_core_rg_name
}

#
# KeyVault
#
data "azurerm_key_vault" "domain_kv" {
  name                = local.idpay_kv_name
  resource_group_name = local.idpay_kv_rg_name
}

### ARGO
data "azurerm_key_vault_secret" "argocd_admin_username" {
  name         = "argocd-admin-username"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

data "azurerm_key_vault_secret" "argocd_admin_password" {
  name         = "argocd-admin-password"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

#
# Azure Kubernetes Service
#
data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = local.aks_resource_group_name
}


data "azurerm_subnet" "private_endpoint_subnet" {
  name                 = "${local.product_no_domain}-platform-storage-private-endpoint-snet"
  virtual_network_name = local.vnet_spoke_platform_name
  resource_group_name  = local.vnet_spoke_platform_rg_name
}

#
# Azure Monitor
#
data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = local.log_analytics_workspace_name
  resource_group_name = local.monitor_resource_group_name
}

data "azurerm_resource_group" "monitor_rg" {
  name = local.monitor_resource_group_name
}

data "azurerm_application_insights" "application_insights" {
  name                = local.application_insights_name
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
}

data "azurerm_resource_group" "apim_rg" {
  name = local.apim_rg_name
}

data "azurerm_api_management" "apim_core" {
  name                = local.apim_name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
}
