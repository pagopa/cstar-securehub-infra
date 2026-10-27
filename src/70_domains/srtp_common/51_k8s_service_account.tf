resource "kubernetes_secret" "ghcr_secret" {
  metadata {
    name      = "ghcr-secret"
    namespace = var.domain
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "ghcr.io" = {
          "email"    = data.azurerm_key_vault_secret.github_docker_pull_email.value
          "username" = data.azurerm_key_vault_secret.github_docker_pull_user.value
          "password" = data.azurerm_key_vault_secret.github_docker_pull_token.value
          "auth" = base64encode(
            "${data.azurerm_key_vault_secret.github_docker_pull_user.value}:${data.azurerm_key_vault_secret.github_docker_pull_token.value}"
          )
        }
      }
    })
  }
}
