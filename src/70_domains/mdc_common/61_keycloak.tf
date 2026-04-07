module "realms_test" {
  source = "./.terraform/modules/__v4__/keycloak_realms_setup"

  realms_configuration = [
    {
      name         = "test-realm-umberto"
      enabled      = true
      display_name = "TEST REALM"
    }
  ]

  domain                = var.domain
  key_vault_name        = data.azurerm_key_vault.kv_domain.name
  key_vault_rg          = data.azurerm_key_vault.kv_domain.resource_group_name
  admin_entra_group_ids = [data.azuread_group.adgroup_domain_externals.object_id]
  #viewer_entra_group_ids = [data.azuread_group.adgroup_domain_externals]

  tags = module.tag_config.tags
}
