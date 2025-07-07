resource "github_branch_default" "default" {
  for_each = toset(keys(local.repository))

  repository = each.key
  branch     = "main"
}

resource "github_branch_protection" "main" {
  for_each = local.repo_branch_map

  repository_id = each.value.repo
  pattern       = each.value.branch

  required_status_checks {
    strict   = true
    contexts = []
  }

  require_conversation_resolution = true
  required_linear_history         = true

  require_signed_commits = false

  required_pull_request_reviews {
    dismiss_stale_reviews           = false
    require_code_owner_reviews      = true
    required_approving_review_count = 1
  }

  allows_deletions = false
}
