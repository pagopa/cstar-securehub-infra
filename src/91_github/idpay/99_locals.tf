locals {
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
    "idpay-self-expense-backend" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-self-expense-backend"
          SONARCLOUD_PROJECT_NAME = "idpay-self-expense-backend"
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
    "idpay-group" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-group"
          SONARCLOUD_PROJECT_NAME = "idpay-group"
        }
      ]
    },
    "idpay-reward-user-id-splitter" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-reward-user-id-splitter"
          SONARCLOUD_PROJECT_NAME = "idpay-reward-user-id-splitter"
        }
      ]
    },
    "idpay-reward-notification" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-reward-notification"
          SONARCLOUD_PROJECT_NAME = "idpay-reward-notification"
        }
      ]
    },
    "idpay-iban" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-iban"
          SONARCLOUD_PROJECT_NAME = "idpay-iban"
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
    "idpay-ranking" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-ranking"
          SONARCLOUD_PROJECT_NAME = "idpay-ranking"
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
    "idpay-outbox-processor" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-outbox-processor"
          SONARCLOUD_PROJECT_NAME = "idpay-outbox-processor"
        }
      ]
    },
    "idpay-self-expense-webview" = {
      repository_secrets = [
        {
          SONAR_TOKEN = data.azurerm_key_vault_secret.sonar_token.value
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG          = "pagopa"
          SONARCLOUD_PROJECT_KEY  = "pagopa_idpay-self-expense-webview"
          SONARCLOUD_PROJECT_NAME = "idpay-self-expense-webview"
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
    },
  }

  protected_branches = ["develop", "main", "uat"]

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

  repo_branch_map = {
    for i in flatten([
      for repo in keys(local.repository) : [
        for branch in local.protected_branches : {
          key    = "${repo}:${branch}"
          repo   = repo
          branch = branch
        }
      ]
      ]) : i.key => {
      repo   = i.repo
      branch = i.branch
    }
  }
}
