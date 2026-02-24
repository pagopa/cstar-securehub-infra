module "keycloak_app" {
  source = "./.terraform/modules/__v4__/keycloak_entra"

  prefix                 = var.prefix
  env                    = var.env
  ad_user_owners         = local.argocd_application_owners
  authorized_group_names = local.argocd_entra_groups_allowed

  redirect_uris = [
    "https://keycloak.itn.internal.dev.cstar.pagopa.it/realms/master/broker/azure-entra/endpoint"
  ]
  logout_url = "https://keycloak.itn.internal.dev.cstar.pagopa.it/realms/master/protocol/openid-connect/logout"
}
