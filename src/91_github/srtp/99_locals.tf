locals {
  project           = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product           = "${var.prefix}-${var.env_short}"
  project_no_domain = "${var.prefix}-${var.env_short}-${var.location_short}"

  cicd_rg_name               = "${local.project}-cicd-rg"
  identities_rg              = "${local.project}-identity-rg"
  rtp_kv_name                = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}-kv"
  rtp_kv_resource_group_name = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}-${var.location_short == "itn" ? "security" : "sec"}-rg"

  current_env = "${var.location_short}-${var.env}"

  # AKS
  aks_name                = "${local.project_no_domain}-${var.env}-aks"
  aks_resource_group_name = "${local.project_no_domain}-core-aks-rg"

  repository = {
    rtp-activator = {
      env_variables = [],
      env_secret_variables = [
        {
          AZURE_CLIENT_ID       = data.azurerm_user_assigned_identity.cd_client_identity.client_id
          AZURE_SUBSCRIPTION_ID = data.azurerm_subscription.current.subscription_id
          AZURE_TENANT_ID       = data.azurerm_client_config.current.tenant_id
          SLACK_WEBHOOK_URL     = data.azurerm_key_vault_secret.slack_webhook.value
        }
      ]
      repository_secrets   = []
      repository_variables = []
    }
    rtp-sender = {
      env_variables = [],
      env_secret_variables = [
        {
          AZURE_CLIENT_ID       = data.azurerm_user_assigned_identity.cd_client_identity.client_id
          AZURE_SUBSCRIPTION_ID = data.azurerm_subscription.current.subscription_id
          AZURE_TENANT_ID       = data.azurerm_client_config.current.tenant_id
          SLACK_WEBHOOK_URL     = data.azurerm_key_vault_secret.slack_webhook.value
        }
      ]
      repository_secrets   = []
      repository_variables = []
    }
    rtp-platform-qa = {
      env = ["${var.location_short}-dev", "${var.location_short}-uat"],
      env_variables = [
        {
          AZURE_RESOURCE_GROUP   = local.aks_resource_group_name
          AZURE_AKS_CLUSTER_NAME = local.aks_name
        }
      ],
      env_secret_variables = [
        {
          AZURE_CLIENT_ID       = data.azurerm_user_assigned_identity.cd_job_github_runner.client_id
          AZURE_SUBSCRIPTION_ID = data.azurerm_subscription.current.subscription_id
          AZURE_TENANT_ID       = data.azurerm_client_config.current.tenant_id
        }
      ]
      repository_secrets   = []
      repository_variables = []
    }
  }

  # Github Environments
  github_environments = {
    for repo_name, repo in local.repository :
    repo_name => repo
    if(
      !contains(keys(repo), "env") || contains(try(repo.env, []), local.current_env)
    )
  }

  # Environment secrets of Environment
  env_secret_variables_flattened = merge([
    for repo_name, repo_data in local.repository : merge([
      for secret_map in repo_data.env_secret_variables : {
        for secret_name, secret_value in secret_map :
        "${repo_name}@${secret_name}" => {
          repository  = repo_name
          environment = "${var.location_short}-${var.env}"
          secret_name = secret_name
          value       = secret_value
        }
      }
    ]...)
  ]...)

  # Environment Variable of the Environment
  env_variable_variables_flattened = merge([
    for repo_name, repo_data in local.repository : merge([
      for env_map in repo_data.env_variables : {
        for env_key, env_value in env_map :
        "${repo_name}@${env_key}" => {
          repository  = repo_name
          environment = "${var.location_short}-${var.env}"
          env_key     = env_key
          env_value   = env_value
        }
      }
    ]...)
  ]...)

  # Environments of the Repository #
  repository_variables_flattened = merge([
    for repo_name, repo_data in local.repository : merge([
      for variable_map in repo_data.repository_variables : {
        for var_name, var_value in variable_map :
        "${repo_name}@${var_name}" => {
          repository    = repo_name
          variable_name = var_name
          value         = var_value
        }
      }
    ]...)
  ]...)

  # Secrets of the Repository #
  repository_secrets_flattened = merge([
    for repo_name, repo_data in local.repository : merge([
      for secret_map in repo_data.repository_secrets : {
        for secret_name, secret_value in secret_map :
        "${repo_name}@${secret_name}" => {
          repository  = repo_name
          secret_name = secret_name
          value       = secret_value
        }
      }
    ]...)
  ]...)
}
