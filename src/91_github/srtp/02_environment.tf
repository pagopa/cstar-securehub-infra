##########################################
# Environment #
##########################################
resource "github_repository_environment" "env" {

  for_each = local.github_environments

  repository          = each.key
  environment         = local.current_env
  can_admins_bypass   = true
  prevent_self_review = true

  reviewers {
    teams = var.env_short == "d" ? [] : [data.github_team.admin.id]
  }
}
