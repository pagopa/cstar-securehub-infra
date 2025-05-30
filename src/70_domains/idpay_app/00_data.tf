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
