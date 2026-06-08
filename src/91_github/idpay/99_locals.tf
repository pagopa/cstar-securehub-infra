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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = []
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
      env = [
        {
          name = "itn-uat"
          secrets = {
            SERVICE_URL = var.datavault_service_url_for_uat
          }
        }
      ]
    }
  }

  # ----------------------------------------------------------------------------
  # Repositories that have one or more explicit environments defined.
  # ----------------------------------------------------------------------------
  repositories_with_environment = merge([
    for repo_name, repo_data in local.repository : {
      for env_cfg in try(repo_data.env, []) :
      "${repo_name}@${env_cfg.name}" => {
        repository  = repo_name
        environment = env_cfg.name
        variables   = try(env_cfg.variables, {})
        secrets     = try(env_cfg.secrets, {})
      }
    }
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
  env_variables_flattened = merge([
    for env_id, env_data in local.repositories_with_environment : {
      for env_key, env_value in env_data.variables :
      "${env_id}@${env_key}" => {
          repository  = env_data.repository
          environment = env_data.environment
          env_key     = env_key
          env_value   = env_value
      }
    }
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
  env_secrets_flattened = merge([
    for env_id, env_data in local.repositories_with_environment : {
      for secret_name, secret_value in env_data.secrets :
      "${env_id}@${secret_name}" => {
          repository  = env_data.repository
          environment = env_data.environment
          secret_name = secret_name
          value       = secret_value
      }
    }
  ]...)
}
