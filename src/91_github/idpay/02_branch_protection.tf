resource "github_branch_default" "default" {
  for_each = toset(keys(local.repository))

  repository = each.key
  branch     = "main"
}

# iterate over the repositories and create branch protection rules for the develop branch
resource "github_repository_ruleset" "develop" {
  for_each = local.repository

  name        = "develop"
  repository  = each.key
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = [
        "refs/heads/develop"
      ]
      exclude = []
    }
  }

  bypass_actors {
    # repository admin
    actor_id    = 13205158
    actor_type  = "Team"
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

    required_code_scanning {
      required_code_scanning_tool {
        tool                      = "CodeQL"
        security_alerts_threshold = "high_or_higher"
        alerts_threshold          = "errors"
      }
    }
  }
}

# iterate over the repositories and create branch protection rules for the develop branch
resource "github_repository_ruleset" "uat_and_main" {
  for_each = local.repository

  name        = "uat_and_main"
  repository  = each.key
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = [
        "refs/heads/uat",
        "refs/heads/main"
      ]
      exclude = []
    }
  }

  bypass_actors {
    # repository admin
    actor_id    = 13205158
    actor_type  = "Team"
    bypass_mode = "always"
  }

  rules {
    creation                = true
    update                  = true
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

    required_code_scanning {
      required_code_scanning_tool {
        tool                      = "CodeQL"
        security_alerts_threshold = "high_or_higher"
        alerts_threshold          = "errors"
      }
    }
  }
}
