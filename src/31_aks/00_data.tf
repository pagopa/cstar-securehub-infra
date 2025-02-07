#
# 🌐 Networking
#
data "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  resource_group_name = local.vnet_resource_group_name
}

data "azurerm_private_dns_zone" "internal" {
  name                = local.internal_dns_zone_name
  resource_group_name = local.internal_dns_zone_resource_group_name
}

#
# AKS & Docker
#

data "azurerm_container_registry" "acr" {
  name                = local.docker_registry_name
  resource_group_name = local.docker_rg_name
}

#
# 🔐 KV
#

data "azurerm_key_vault" "key_vault_core" {
  name                = local.kv_name_core
  resource_group_name = local.rg_name_core_security
}

data "azurerm_key_vault_secret" "argocd_admin_username" {
  name         = "argocd-admin-username"
  key_vault_id = data.azurerm_key_vault.key_vault_core.id
}

data "azurerm_key_vault_secret" "argocd_admin_password" {
  name         = "argocd-admin-password"
  key_vault_id = data.azurerm_key_vault.key_vault_core.id
}
