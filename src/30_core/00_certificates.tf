#
# 📝 Certificate
#

data "azurerm_key_vault_certificate" "api_cstar" {
  name         = local.app_gateway_api_certificate_name
  key_vault_id = local.kv_id_core
}

data "azurerm_key_vault_certificate" "api_mtls_cstar" {
  name         = local.app_gateway_api_mtls_certificate_name
  key_vault_id = local.kv_id_core
}

data "azurerm_key_vault_certificate" "portal_cstar" {
  name         = local.app_gateway_portal_certificate_name
  key_vault_id = local.kv_id_core
}

data "azurerm_key_vault_certificate" "management_cstar" {
  name         = local.app_gateway_management_certificate_name
  key_vault_id = local.kv_id_core
}
