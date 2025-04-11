data "azurerm_key_vault" "kv" {
  name                = local.kv_name_core_security
  resource_group_name = local.kv_rg_name_core_security
}
