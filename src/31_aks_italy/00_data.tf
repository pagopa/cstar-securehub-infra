#
# 🔐 KV
#
data "azurerm_key_vault" "kv_core" {
  name                = local.kv_name_core_security
  resource_group_name = local.kv_rg_name_core_security
}

data "azurerm_key_vault" "kv_cicd" {
  name                = local.kv_name_cicd_security
  resource_group_name = local.kv_rg_name_core_security
}

data "azurerm_key_vault_secret" "argocd_admin_username" {
  name         = "argocd-admin-username"
  key_vault_id = data.azurerm_key_vault.kv_cicd.id
}

data "azurerm_key_vault_secret" "argocd_admin_password" {
  name         = "argocd-admin-password"
  key_vault_id = data.azurerm_key_vault.kv_cicd.id
}

#
# Compute spoke VNET
#
data "azurerm_resource_group" "vnet_compute_spoke_rg" {
  name = "${local.project}-network-rg"
}

data "azurerm_virtual_network" "vnet_compute_spoke" {
  name                = "${local.project}-spoke-compute-vnet"
  resource_group_name = data.azurerm_resource_group.vnet_compute_spoke_rg.name
}
