# 🔎 DNS
data "azurerm_private_dns_zone" "cosmos_mongo" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = local.vnet_legacy_core_rg
}

data "azurerm_private_dns_zone" "blob_storage" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = local.vnet_legacy_core_rg
}

data "azurerm_private_dns_zone" "file_storage" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = local.network_rg
}

# 🔐 KV
data "azurerm_key_vault" "domain_kv" {
  name                = local.key_vault_name
  resource_group_name = local.key_vault_rg_name
}

# 📊 Monitoring
data "azurerm_application_insights" "appinsights" {
  name                = local.application_insights_name
  resource_group_name = local.monitor_resource_group_name
}

data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = local.log_analytics_workspace_name
  resource_group_name = local.monitor_resource_group_name
}
