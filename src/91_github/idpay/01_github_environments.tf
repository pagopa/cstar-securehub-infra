# ------------------------------------------------------------------------------
# Repository variables.
# ------------------------------------------------------------------------------
resource "github_actions_variable" "repository_variables" {
  for_each = var.env == "prod" ? local.repository_variables_flattened : {}

  repository    = each.value.repository
  variable_name = each.value.variable_name
  value         = each.value.value
}

# ------------------------------------------------------------------------------
# Repository secrets.
# ------------------------------------------------------------------------------
resource "github_actions_secret" "repository_secrets" {
  for_each = var.env == "prod" ? local.repository_secrets_flattened : {}

  repository      = each.value.repository
  secret_name     = each.value.secret_name
  plaintext_value = each.value.value
}

# ------------------------------------------------------------------------------
# Repository environment.
# ------------------------------------------------------------------------------
resource "github_repository_environment" "env" {
  for_each = local.repositories_with_environment

  repository          = each.value.repository
  environment         = each.value.environment
  can_admins_bypass   = true
  prevent_self_review = true
}

# ------------------------------------------------------------------------------
# Environment secrets.
# ------------------------------------------------------------------------------
resource "github_actions_environment_secret" "env_secrets" {
  for_each = local.env_secrets_flattened

  repository      = each.value.repository
  environment     = each.value.environment
  secret_name     = each.value.secret_name
  plaintext_value = each.value.value

  depends_on = [github_repository_environment.env]
}

# ------------------------------------------------------------------------------
# Environment variables.
# ------------------------------------------------------------------------------
resource "github_actions_environment_variable" "env_variables" {
  for_each = local.env_variables_flattened

  repository    = each.value.repository
  environment   = each.value.environment
  variable_name = each.value.env_key
  value         = each.value.env_value

  depends_on = [github_repository_environment.env]
}
