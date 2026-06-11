locals {
  # ----------------------------------------------------------------------------
  # Repository configuration.
  # ----------------------------------------------------------------------------
  repository = {
    "idpay-asset-register-backend" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-asset-register-backend"
          SONARCLOUD_PROJECT_NAME = "idpay-asset-register-backend"
        }
      ]
    },
    "idpay-payment-instrument" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-payment-instrument"
          SONARCLOUD_PROJECT_NAME = "idpay-payment-instrument"
        }
      ]
    },
    "idpay-portal-merchants-frontend" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-portal-merchants-frontend"
          SONARCLOUD_PROJECT_NAME = "idpay-portal-merchants-frontend"
        }
      ]
    },
    "idpay-recovery-error-topic" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-recovery-error-topic"
          SONARCLOUD_PROJECT_NAME = "idpay-recovery-error-topic"
        }
      ]
    },
    "idpay-reward-calculator" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-reward-calculator"
          SONARCLOUD_PROJECT_NAME = "idpay-reward-calculator"
        }
      ]
    },
    "idpay-merchant" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-merchant"
          SONARCLOUD_PROJECT_NAME = "idpay-merchant"
        }
      ]
    },
    "idpay-transactions" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-transactions"
          SONARCLOUD_PROJECT_NAME = "idpay-transactions"
        }
      ]
    },
    "idpay-initiative-statistics" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-initiative-statistics"
          SONARCLOUD_PROJECT_NAME = "idpay-initiative-statistics"
        }
      ]
    },
    "idpay-onboarding-workflow" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-onboarding-workflow"
          SONARCLOUD_PROJECT_NAME = "idpay-onboarding-workflow"
        }
      ]
    },
    "idpay-admissibility-assessor" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-admissibility-assessor"
          SONARCLOUD_PROJECT_NAME = "idpay-admissibility-assessor"
        }
      ]
    },
    "idpay-wallet" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-wallet"
          SONARCLOUD_PROJECT_NAME = "idpay-wallet"
        }
      ]
    },
    "idpay-timeline" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-timeline"
          SONARCLOUD_PROJECT_NAME = "idpay-timeline"
        }
      ]
    },
    "idpay-portal-welfare-backend-initiative" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-portal-welfare-backend-initiative"
          SONARCLOUD_PROJECT_NAME = "idpay-portal-welfare-backend-initiative"
        }
      ]
    },
    "idpay-notification-email" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-notification-email"
          SONARCLOUD_PROJECT_NAME = "idpay-notification-email"
        }
      ]
    },
    "idpay-notification-manager" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-notification-manager"
          SONARCLOUD_PROJECT_NAME = "idpay-notification-manager"
        }
      ]
    },
    "idpay-kafka-connect" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-kafka-connect"
          SONARCLOUD_PROJECT_NAME = "idpay-kafka-connect"
        }
      ]
    },
    "idpay-mock" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-mock"
          SONARCLOUD_PROJECT_NAME = "idpay-mock"
        }
      ]
    },
    "idpay-portal-users-frontend" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-portal-users-frontend"
          SONARCLOUD_PROJECT_NAME = "idpay-portal-users-frontend"
        }
      ]
    },
    "idpay-payment" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-payment"
          SONARCLOUD_PROJECT_NAME = "idpay-payment"
        }
      ]
    },
    "idpay-portal-merchants-operator-frontend" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-portal-merchants-operator-frontend"
          SONARCLOUD_PROJECT_NAME = "idpay-portal-merchants-operator-frontend"
        }
      ]
    },
    "idpay-portal-welfare-frontend" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-portal-welfare-frontend"
          SONARCLOUD_PROJECT_NAME = "idpay-portal-welfare-frontend"
        }
      ]
    },
    "idpay-asset-register-frontend" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-asset-register-frontend"
          SONARCLOUD_PROJECT_NAME = "idpay-asset-register-frontend"
        }
      ]
    },
    "idpay-product-catalog-portal" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-product-catalog-portal"
          SONARCLOUD_PROJECT_NAME = "idpay-product-catalog-portal"
        }
      ]
    },
    "idpay-portal-welfare-backend-role-permission" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-portal-welfare-backend-role-permission"
          SONARCLOUD_PROJECT_NAME = "idpay-portal-welfare-backend-role-permission"
        }
      ]
    },
    "idpay-ranker" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-ranker"
          SONARCLOUD_PROJECT_NAME = "idpay-ranker"
        }
      ]
    },
    "pari-performance-test" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_pari-performance-test"
          SONARCLOUD_PROJECT_NAME = "pari-performance-test"
        }
      ]
    },
    "mcshared-datavault" = {
      settings = {
        apply            = true
        description      = "MC-Shared Data Vault"
        primary_language = "Java"
        visibility       = "internal"
      }
      protected_branches = ["main"]
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_mcshared-datavault"
          SONARCLOUD_PROJECT_NAME = "mcshared-datavault"
        }
      ]
      env_secrets = {
        envs = ["uat", "prod"]
        secrets = {
          ARGO_CD_USERNAME = data.azurerm_key_vault_secret.argo_cd_username.value
          ARGO_CD_PASSWORD = data.azurerm_key_vault_secret.argo_cd_password.value
        }
      }
      env_variables = {
        envs = ["uat", "prod"]
        variables = {
          ARGO_CD_SERVER = var.argo_cd_server
        }
      }
    },
    "mcshared-datavault-test" = {
      settings = {
        apply       = true
        description = "MC-Shared Data Vault Test"
        visibility  = "private"
      }
      protected_branches   = ["main"]
      repository_secrets   = []
      repository_variables = []
      env_variables = {
        envs = ["uat"]
        variables = {
          SERVICE_URL = var.datavault_service_url
        }
      }
    }
  }

  # ----------------------------------------------------------------------------
  # Repositories with environment configuration.
  # ----------------------------------------------------------------------------
  repositories_with_environment = merge({}, [
    for repo_name, repo_data in local.repository : {
      "${repo_name}@${var.env}" = {
        repository  = repo_name
        environment = var.env
        variables   = contains(try(repo_data.env_variables.envs, []), var.env) ? try(repo_data.env_variables.variables, {}) : {}
        secrets     = contains(try(repo_data.env_secrets.envs, []), var.env) ? try(repo_data.env_secrets.secrets, {}) : {}
      }
    }
    if(
      contains(try(repo_data.env_variables.envs, []), var.env) ||
      contains(try(repo_data.env_secrets.envs, []), var.env)
    )
  ]...)

  # ----------------------------------------------------------------------------
  # Repositories that require repository settings management.
  # ----------------------------------------------------------------------------
  repositories_with_settings = {
    for repo_name, repo_data in local.repository : repo_name => repo_data
    if try(repo_data.settings.apply, false)
  }

  # ----------------------------------------------------------------------------
  # Default protected branches.
  #
  # Used if a repository does not define its own protected branches.
  # ----------------------------------------------------------------------------
  protected_branches = ["develop", "main", "uat"]

  # ----------------------------------------------------------------------------
  # Map of repositories and their protected branches.
  #
  # If a repository does not define its own protected branches, the default ones
  # are used.
  # ----------------------------------------------------------------------------
  protected_branches_by_repo = {
    for repo_name, repo_data in local.repository :
    repo_name => lookup(repo_data, "protected_branches", local.protected_branches)
  }

  # ----------------------------------------------------------------------------
  # Repositories that have develop branch protected.
  # ----------------------------------------------------------------------------
  repositories_with_develop_ruleset = {
    for repo_name, repo_data in local.repository : repo_name => repo_data
    if contains(local.protected_branches_by_repo[repo_name], "develop")
  }

  # ----------------------------------------------------------------------------
  # Repositories that have either uat or main branch protected.
  # ----------------------------------------------------------------------------
  repositories_with_uat_and_main_ruleset = {
    for repo_name in keys(local.repository) : repo_name => {
      include_refs = [
        for branch in ["uat", "main"] : "refs/heads/${branch}"
        if contains(local.protected_branches_by_repo[repo_name], branch)
      ]
    }
    if(contains(local.protected_branches_by_repo[repo_name], "uat") || contains(local.protected_branches_by_repo[repo_name], "main"))
  }

  # ----------------------------------------------------------------------------
  # Flattened maps for repository variables.
  # ----------------------------------------------------------------------------
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

  # ----------------------------------------------------------------------------
  # Flattened maps for environment variables.
  # ----------------------------------------------------------------------------
  env_variables_flattened = merge({}, [
    for env_id, env_data in local.repositories_with_environment : {
      for env_key, env_value in env_data.variables :
      "${env_id}@${env_key}" => {
        repository  = env_data.repository
        environment = env_data.environment
        env_key     = env_key
        env_value   = env_value
      }
    }
    if contains(try(local.repository[env_data.repository].env_variables.envs, []), var.env)
  ]...)

  # ----------------------------------------------------------------------------
  # Flattened maps for repository secrets.
  # ----------------------------------------------------------------------------
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

  # ----------------------------------------------------------------------------
  # Flattened maps for environment secrets.
  # ----------------------------------------------------------------------------
  env_secrets_flattened = merge({}, [
    for env_id, env_data in local.repositories_with_environment : {
      for secret_name, secret_value in env_data.secrets :
      "${env_id}@${secret_name}" => {
        repository  = env_data.repository
        environment = env_data.environment
        secret_name = secret_name
        value       = secret_value
      }
    }
    if contains(try(local.repository[env_data.repository].env_secrets.envs, []), var.env)
  ]...)
}
