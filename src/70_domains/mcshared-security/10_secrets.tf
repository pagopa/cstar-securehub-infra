# ------------------------------------------------------------------------------
# Storing auth key vault URL in the general key vault.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "key_vault_auth_vault_uri" {
  name         = "key-vault-auth-vault-uri"
  value        = module.key_vault["auth"].vault_uri
  key_vault_id = module.key_vault["gen"].id
  tags         = module.tag_config.tags

  depends_on = [
    module.admins_policy,
    module.developers_policy,
    module.externals_policy
  ]
}
