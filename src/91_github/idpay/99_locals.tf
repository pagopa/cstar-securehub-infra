locals {
  repository = {
    "idpay-asset-register-backend" = {
      repository_secrets = [
        {
          SONAR_TOKEN = "TEST"
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = ""
          SONARCLOUD_PROJECT_NAME = ""
        }
      ]
    }
  }
  repository_variables_flattened = merge([
    for repo_name, repo_data in local.repository : merge([
      for variable_map in repo_data.repository_variables : {
        for var_name, var_value in variable_map :
        "${repo_name}_${var_name}" => {
          repository    = repo_name
          variable_name = var_name
          value         = var_value
        }
      }
    ]...)
  ]...)

  repository_secrets_flattened = merge([
    for repo_name, repo_data in local.repository : merge([
      for secret_map in repo_data.repository_secrets : {
        for secret_name, secret_value in secret_map :
        "${repo_name}_${secret_name}" => {
          repository  = repo_name
          secret_name = secret_name
          value       = secret_value
        }
      }
    ]...)
  ]...)
}
