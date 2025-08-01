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

##########################################
# Environment Variables of the Environment #
##########################################

resource "github_actions_environment_variable" "env_variables" {
  for_each = local.env_variable_variables_flattened

  repository    = each.value.repository
  environment   = each.value.environment
  variable_name = each.value.env_key
  value         = each.value.env_value

  depends_on = [github_repository_environment.env]
}
