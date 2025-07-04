##########################################
# Environment Variable of the Repository #
##########################################
resource "github_actions_variable" "repository_variables" {
  for_each = var.env_short == "p" ? local.repository_variables_flattened : {}

  repository    = each.value.repository
  variable_name = each.value.variable_name
  value         = each.value.value
}

#############################
# Secrets of the Repository #
#############################
resource "github_actions_secret" "repository_secrets" {
  for_each = var.env_short == "p" ? local.repository_secrets_flattened : {}

  repository      = each.value.repository
  secret_name     = each.value.secret_name
  plaintext_value = each.value.value
}
