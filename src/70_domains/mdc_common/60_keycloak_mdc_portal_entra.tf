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
  domain                 = "mdc-internal-portal" # display name: <prefix>-<env>-mdc-internal-portal-keycloak
  ad_user_owners         = local.application_owners
  authorized_group_names = local.mdc_portal_groups

  redirect_uris = [
    "${local.keycloak_external_hostname}/realms/mdc/broker/azure-entra/endpoint"
  ]
  logout_url = "${local.keycloak_external_hostname}/realms/mdc/protocol/openid-connect/logout"
}
