resource "github_branch_default" "default" {
  for_each = toset(keys(local.repository))

  repository = each.key
  branch     = "main"
}

# iterate over the repositories and create branch protection rules for the develop branch
resource "github_repository_ruleset" "pari" {
  for_each = local.repository

  name        = "PARI"
  repository  = each.key
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = [
        "refs/heads/develop",
        "refs/heads/uat",
        "refs/heads/main"
      ]
      exclude = []
    }
  }

  bypass_actors {
    # repository admin
    actor_id    = 5
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }

  rules {
    creation                = true
    update                  = false
    deletion                = true
    non_fast_forward        = true
    required_linear_history = true

    pull_request {
      require_code_owner_review         = true
      required_approving_review_count   = 2
      dismiss_stale_reviews_on_push     = true
      required_review_thread_resolution = true
      require_last_push_approval        = false
    }

    required_status_checks {
      strict_required_status_checks_policy = true
      do_not_enforce_on_create             = false
      required_check {
        context        = "SonarCloud Code Analysis"
        integration_id = 12526
      }
    }
  }
}
