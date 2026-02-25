module "keycloak_app" {
  source = "./.terraform/modules/__v4__/keycloak_entra"

  prefix                 = var.prefix
  env                    = var.env
  ad_user_owners         = local.application_owners
  authorized_group_names = local.entra_groups_allowed

  redirect_uris = [
    "https://${local.keycloak_hostname}/realms/hub-spoke/broker/azure-entra/endpoint",
    "https://${local.keycloak_hostname}/realms/master/broker/azure-entra/endpoint"
  ]
  logout_url = "https://${local.keycloak_hostname}/realms/hub-spoke/protocol/openid-connect/logout"
}

resource "azurerm_key_vault_secret" "keycloak_client_id" {
  name         = "keycloak-azure-app-client-id"
  value        = module.keycloak_app.azure_client_id
  key_vault_id = data.azurerm_key_vault.kv_core.id

  tags = module.tag_config.tags
}


resource "azurerm_key_vault_secret" "keycloak_client_secret" {
  name         = "keycloak-azure-app-secret-value"
  value        = module.keycloak_app.azure_client_secret
  key_vault_id = data.azurerm_key_vault.kv_core.id

  tags = module.tag_config.tags
}
