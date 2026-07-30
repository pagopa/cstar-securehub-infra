# =============================================================================
# App Registration DEDICATA per il login degli utenti del portale interno mdc
# (realm mdc di Keycloak).
#
# Separata dall'app "keycloak_app" (usata per admin console Keycloak e ArgoCD):
# - accessi/gruppi del portale gestiti in modo indipendente (mdc_portal_groups)
# - blast radius ridotto (secret dedicato)
# - lifecycle e consent separati
#
# =============================================================================
module "keycloak_mdc_portal_app" {
  source = "./.terraform/modules/__v4__/keycloak_entra"

  prefix                 = var.prefix
  env                    = var.env
  domain                 = "mdc" # display name: <prefix>-<env>-mdc-keycloak
  ad_user_owners         = local.application_owners
  authorized_group_names = local.mdc_portal_groups

  redirect_uris = [
    "https://${local.keycloak_hostname}/realms/mdc/broker/azure-entra/endpoint"
  ]
  logout_url = "https://${local.keycloak_hostname}/realms/mdc/protocol/openid-connect/logout"
}

resource "azurerm_key_vault_secret" "keycloak_mdc_portal_client_id" {
  name         = "keycloak-mdc-portal-azure-app-client-id"
  value        = module.keycloak_mdc_portal_app.azure_client_id
  key_vault_id = data.azurerm_key_vault.kv_core.id

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "keycloak_mdc_portal_client_secret" {
  name         = "keycloak-mdc-portal-azure-app-secret-value"
  value        = module.keycloak_mdc_portal_app.azure_client_secret
  key_vault_id = data.azurerm_key_vault.kv_core.id

  tags = module.tag_config.tags
}

