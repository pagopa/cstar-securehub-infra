module "secrets" {
  source = "./.terraform/modules/__v4__/key_vault_secrets_query"

  key_vault_name = local.kv_domain_name
  resource_group = local.kv_domain_rg_name

  secrets = compact([
    "argocd-admin-username",
    "argocd-admin-password",
    var.env_short == "p" ? "opsgenie-api-key" : null,
    "ar-backoffice-client-id",
    "ar-backoffice-client-secret",
    "ar-backoffice-admin-client-id",
    "ar-backoffice-admin-client-secret"
  ])
}
