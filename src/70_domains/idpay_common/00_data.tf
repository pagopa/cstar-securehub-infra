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
