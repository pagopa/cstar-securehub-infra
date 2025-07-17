resource "github_branch_default" "default" {
  for_each = toset(keys(local.repository))

  repository = each.key
  branch     = "main"
}


# iterate over the repositories and create branch protection rules for the develop branch
resource "github_repository_ruleset" "dev" {
  for_each = local.repository

  name        = "dev"
  repository  = each.key
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/develop"]
      exclude = []
    }
  }

  rules {
    creation                = true
    update                  = false
    deletion                = true
    required_linear_history = false
    required_signatures     = false

    pull_request {
      require_code_owner_review         = true
      required_approving_review_count   = 1
      dismiss_stale_reviews_on_push     = true
      required_review_thread_resolution = true
    }
  }
}

# iterate over the repositories and create branch protection rules for the develop branch
resource "github_repository_ruleset" "uat_prod" {
  for_each = local.repository

  name        = "uat_prod"
  repository  = each.key
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/uat", "refs/heads/main"]
      exclude = []
    }
  }

  rules {
    creation                = true
    update                  = false
    deletion                = true
    required_linear_history = false
    required_signatures     = false

    pull_request {
      require_code_owner_review         = true
      required_approving_review_count   = 1
      dismiss_stale_reviews_on_push     = true
      required_review_thread_resolution = true
    }
  }
}
