##########################################
# Environment #
##########################################
resource "github_repository_environment" "env" {

  for_each = toset(keys(local.repository))

  repository          = each.key
  environment         = "${var.location_short}-${var.env}"
  can_admins_bypass   = true
  prevent_self_review = true

  reviewers {
    teams = var.env_short == "d" ? [] : [data.github_team.admin.id]
  }
}
