resource "azurerm_key_vault_key" "sops_key" {
  for_each = toset(local.secrets_folders_kv)

  name         = "${local.project_nodomain}-${each.key}-sops-key"
  key_vault_id = module.key_vault[each.key].id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
  ]

  depends_on = [
    azurerm_key_vault_access_policy.admins_group_policy,
    azurerm_key_vault_access_policy.developers_policy,
  ]
}
