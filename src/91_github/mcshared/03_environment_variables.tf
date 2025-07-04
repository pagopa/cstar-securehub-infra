##########################################
# Secrets of the Environment #
##########################################
resource "github_actions_environment_secret" "env_secrets" {
  for_each = local.env_secret_variables_flattened

  repository      = each.value.repository
  environment     = each.value.environment
  secret_name     = each.value.secret_name
  plaintext_value = each.value.value

  depends_on = [github_repository_environment.env]
}
