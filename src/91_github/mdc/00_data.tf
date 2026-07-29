data "github_team" "admin" {
  slug = "emd-team-admin"
}

module "secrets" {
  source = "./.terraform/modules/__v4__/key_vault_secrets_query"

  key_vault_name = var.mdc_kv_name
  resource_group = var.mdc_kv_rg

  secrets = compact([
    var.env == "prod" ? "argocd-admin-username" : null,
    var.env == "prod" ? "argocd-admin-password" : null,
    var.env == "prod" ? "mil-gh-bot-token" : null,
    var.env == "prod" ? "emd-bot-github-rw-TOKEN" : null,
    var.env == "prod" ? "sonar-token" : null,
    var.env == "uat" ? "argocd-admin-username" : null,
    var.env == "uat" ? "argocd-admin-password" : null,
    var.env == "uat" ? "emd-tpp-test-client-id" : null,
    var.env == "uat" ? "emd-tpp-test-client-secret" : null,
    var.env == "uat" ? "send-client-id" : null,
    var.env == "uat" ? "send-client-secret" : null,
    var.env == "uat" ? "keycloak-external-mdc-url" : null,
    var.env == "uat" ? "kafka-password" : null
  ])
}
