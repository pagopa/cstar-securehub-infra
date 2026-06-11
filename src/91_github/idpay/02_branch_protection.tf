# ------------------------------------------------------------------------------
# Default branch: main
#
# APPLIED ONLY WHEN TERRAFORM IS APPLIED IN PROD ENVIRONMENT.
# ------------------------------------------------------------------------------
resource "github_branch_default" "default" {
  for_each = var.env == "prod" ? toset(keys(local.repository)) : {}

  repository = each.key
  branch     = "main"
}

# ------------------------------------------------------------------------------
# Apply this ruleset only for repositories that have develop branch protected.
#
# APPLIED ONLY WHEN TERRAFORM IS APPLIED IN PROD ENVIRONMENT.
# ------------------------------------------------------------------------------
resource "github_repository_ruleset" "develop" {
  for_each = var.env == "prod" ? local.repositories_with_develop_ruleset : {}

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
    actor_id    = data.github_team.admin.id
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

      allowed_merge_methods = ["squash"]
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

# ------------------------------------------------------------------------------
# Apply this ruleset only for repositories that have uat or main branch
# protected.
#
# APPLIED ONLY WHEN TERRAFORM IS APPLIED IN PROD ENVIRONMENT.
# ------------------------------------------------------------------------------
resource "github_repository_ruleset" "uat_and_main" {
  for_each = var.env == "prod" ? local.repositories_with_uat_and_main_ruleset : {}

  name        = "uat_and_main"
  repository  = each.key
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = each.value.include_refs
      exclude = []
    }
  }

  bypass_actors {
    actor_id    = data.github_team.admin.id
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
      allowed_merge_methods             = ["merge"]
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
