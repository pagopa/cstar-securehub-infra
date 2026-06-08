#-------------------------------------------------------------------------------
# GitHub repository settings.
#
# The repository settings are applied only when terraform is applied in prod
# environment.
#-------------------------------------------------------------------------------
resource "github_repository" "repository_settings" {
  for_each = var.env == "prod" ? local.repositories_with_settings : {}

  allow_auto_merge            = try(each.value.settings.allow_auto_merge, false)
  allow_forking               = try(each.value.settings.allow_forking, false)
  allow_merge_commit          = try(each.value.settings.allow_merge_commit, true)
  allow_rebase_merge          = try(each.value.settings.allow_rebase_merge, false)
  allow_squash_merge          = try(each.value.settings.allow_squash_merge, true)
  allow_update_branch         = try(each.value.settings.allow_update_branch, false)
  archived                    = try(each.value.settings.archived, false)
  auto_init                   = try(each.value.settings.auto_init, false)
  delete_branch_on_merge      = try(each.value.settings.delete_branch_on_merge, true)
  description                 = try(each.value.settings.description, "MC-Shared Data Vault")
  fork                        = try(each.value.settings.fork, false)
  has_discussions             = try(each.value.settings.has_discussions, false)
  has_issues                  = try(each.value.settings.has_issues, false)
  has_projects                = try(each.value.settings.has_projects, false)
  has_wiki                    = try(each.value.settings.has_wiki, false)
  homepage_url                = try(each.value.settings.homepage_url, null)
  is_template                 = try(each.value.settings.is_template, false)
  merge_commit_message        = try(each.value.settings.merge_commit_message, "BLANK")
  merge_commit_title          = try(each.value.settings.merge_commit_title, "PR_TITLE")
  name                        = try(each.value.settings.name, each.key)
  squash_merge_commit_message = try(each.value.settings.squash_merge_commit_message, "BLANK")
  squash_merge_commit_title   = try(each.value.settings.squash_merge_commit_title, "PR_TITLE")
  topics                      = try(each.value.settings.topics, [])
  visibility                  = try(each.value.settings.visibility, "internal")
  web_commit_signoff_required = try(each.value.settings.web_commit_signoff_required, false)

  security_and_analysis {
    secret_scanning {
      status = try(each.value.settings.security_and_analysis.secret_scanning.status, "enabled")
    }
    secret_scanning_push_protection {
      status = try(each.value.settings.security_and_analysis.secret_scanning_push_protection.status, "enabled")
    }
  }
}