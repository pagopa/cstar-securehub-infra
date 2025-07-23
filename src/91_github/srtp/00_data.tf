data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}


data "github_team" "admin" {
  slug = "rtp-team-admin"
}

data "azurerm_user_assigned_identity" "cd_client_identity" {
  name                = "${local.project}-github-cd-id"
  resource_group_name = local.cicd_rg_name
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
