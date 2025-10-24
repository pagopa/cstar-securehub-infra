resource "azurerm_key_vault_key" "sops" {
  name         = "${local.project}-sops-key"
  key_vault_id = module.key_vault[var.domain].id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
  ]

  tags = module.tag_config.tags
}
