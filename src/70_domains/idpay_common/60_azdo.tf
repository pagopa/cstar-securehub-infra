# #
# # AZDO
# #
# data "azurerm_user_assigned_identity" "iac_federated_azdo" {
#   for_each            = local.azdo_iac_managed_identities
#   name                = each.key
#   resource_group_name = local.azdo_managed_identity_rg_name
# }
#
# resource "azurerm_key_vault_access_policy" "azdevops_iac_managed_identities" {
#   for_each = local.azdo_iac_managed_identities
#
#   key_vault_id = module.key_vault_idpay.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = data.azurerm_user_assigned_identity.iac_federated_azdo[each.key].principal_id
#
#   key_permissions    = ["Get", "List", "Decrypt", "Verify", "GetRotationPolicy"]
#   secret_permissions = ["Get", "List", "Set", ]
#
#   certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get"]
#
#   storage_permissions = []
# }
