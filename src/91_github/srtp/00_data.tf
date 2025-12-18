data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}


data "github_team" "admin" {
  slug = "rtp-team-admin"
}

data "azurerm_user_assigned_identity" "cd_client_identity" {
  name                = "${local.project}-github-cd-id"
  resource_group_name = local.cicd_rg_name
}

data "azurerm_user_assigned_identity" "cd_job_github_runner" {
  name                = "${local.product}-${var.domain}-job-01-github-cd-identity"
  resource_group_name = local.identities_rg
}

# ------------------------------------------------------------------------------
# General purpose key vault used to protect secrets.
# ------------------------------------------------------------------------------
data "azurerm_key_vault" "rtp-kv" {
  name                = local.rtp_kv_name
  resource_group_name = local.rtp_kv_resource_group_name
}

# Key Vault - Slack webhook
data "azurerm_key_vault_secret" "slack_webhook" {
  key_vault_id = data.azurerm_key_vault.rtp-kv.id
  name         = "slack-webhook-url"
}

data "azurerm_key_vault_secret" "git_pat" {
  key_vault_id = data.azurerm_key_vault.rtp-kv.id
  name         = "git-pat"
}

data "azurerm_key_vault_secret" "sonar_token" {
  key_vault_id = data.azurerm_key_vault.rtp-kv.id
  name         = "sonar-token"
}
