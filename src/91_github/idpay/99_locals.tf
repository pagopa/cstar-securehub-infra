locals {
  project                = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  github_environment     = "${var.location_short}-${var.env}"
  github_deployer_scopes = ["${var.prefix}-${var.env_short}-${var.location_short}-platform-compute-rg"]

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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
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
      env_secrets   = []
      env_variables = []
    },
    "mcshared-datavault" = {
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
      env_secrets   = []
      env_variables = []
    },
    "mcshared-datavault-test" = {
      protected_branches = ["main"]
      repository_secrets = [
        {
          AZURE_TENANT_ID = data.azurerm_client_config.current.tenant_id
          GIT_PAT         = data.azurerm_key_vault_secret.gh_token.value
        }
      ]
      repository_variables = []
      env_secrets = [
        {
          SERVICE_URL = var.datavault_service_url
        }
      ]
      env_variables = []
    },
  }

  # ----------------------------------------------------------------------------
  # Repositories that have environment secrets or variables defined.
  # ----------------------------------------------------------------------------
  repositories_with_environment = {
    for repo_name, repo_data in local.repository : repo_name => repo_data
    if length(repo_data.env_secrets) > 0 || length(repo_data.env_variables) > 0
  }

  # ----------------------------------------------------------------------------
  # Repositories that require GitHub OIDC federation with Azure.
  #
  # A federated identity credential is created only for repositories that define
  # AZURE_CLIENT_ID in repository or environment secrets/variables.
  # ----------------------------------------------------------------------------
  repositories_with_federated_identity = toset([
    for repo_name, repo_data in local.repository : repo_name
    if anytrue(concat(
      [for secret_map in repo_data.repository_secrets : contains(keys(secret_map), "AZURE_CLIENT_ID")],
      [for variable_map in repo_data.repository_variables : contains(keys(variable_map), "AZURE_CLIENT_ID")],
      [for env_secret_map in repo_data.env_secrets : contains(keys(env_secret_map), "AZURE_CLIENT_ID")],
      [for env_variable_map in repo_data.env_variables : contains(keys(env_variable_map), "AZURE_CLIENT_ID")]
    ))
  ])

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
  #
  # The develop ruleset is applied only when terraform is applied in prod
  # environment.
  # ----------------------------------------------------------------------------
  repositories_with_develop_ruleset = {
    for repo_name, repo_data in local.repository : repo_name => repo_data
    if contains(local.protected_branches_by_repo[repo_name], "develop")
  }

  # ----------------------------------------------------------------------------
  # Repositories that have either uat or main branch protected.
  #
  # The uat_and_main ruleset is applied only when terraform is applied in prod
  # environment.
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
        "${repo_name}_${var_name}" => {
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
    for repo_name, repo_data in local.repository : merge([
      for env_map in repo_data.env_variables : {
        for env_key, env_value in env_map :
        "${repo_name}@${env_key}" => {
          repository  = repo_name
          environment = local.github_environment
          env_key     = env_key
          env_value   = env_value
        }
      }
    ]...)
  ]...)

  # ----------------------------------------------------------------------------
  # Flattened maps for repository secrets.
  # ----------------------------------------------------------------------------
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

  # ----------------------------------------------------------------------------
  # Flattened maps for environment secrets.
  # ----------------------------------------------------------------------------
  env_secrets_flattened = merge([
    for repo_name, repo_data in local.repository : merge([
      for secret_map in repo_data.env_secrets : {
        for secret_name, secret_value in secret_map :
        "${repo_name}@${secret_name}" => {
          repository  = repo_name
          environment = local.github_environment
          secret_name = secret_name
          value       = secret_value
        }
      }
    ]...)
  ]...)
}
