locals {
  project      = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  cicd_rg_name = "${local.project}-cicd-rg"

  repository = {
    "mil-auth" = {
      env_variables = [],
      env_secret_variables = [
        {
          AZURE_CLIENT_ID       = data.azurerm_user_assigned_identity.cd_client_identity.client_id
          AZURE_SUBSCRIPTION_ID = data.azurerm_subscription.current.subscription_id
          AZURE_TENANT_ID       = data.azurerm_client_config.current.tenant_id
        }
      ]
      repository_secrets   = []
      repository_variables = []
    }
  }
  # Environment Secrets of the Repository #
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
