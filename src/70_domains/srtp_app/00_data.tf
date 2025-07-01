# 🔐 KV
data "azurerm_key_vault" "domain_kv" {
  name                = local.key_vault_name
  resource_group_name = local.key_vault_rg_name
}

#
# RG
#
data "azurerm_resource_group" "srtp_monitoring_rg" {
  name = local.monitor_resource_group_name
}

data "azurerm_resource_group" "compute_rg" {
  name = local.compute_rg
}
