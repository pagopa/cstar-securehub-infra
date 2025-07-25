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
    module.admins_policy,
    module.developers_policy,
  ]
}
