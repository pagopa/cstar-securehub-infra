locals {
  # ----------------------------------------------------------------------------
  # Repository configuration.
  # ----------------------------------------------------------------------------
  repository = {
    "emd-ar-backoffice-bff" = {
      settings = {
        apply                       = true
        allow_forking               = true
        allow_merge_commit          = false
        allow_update_branch         = true
        description                 = "Backend for Frontend del Backoffice Area Riservata di Messaggi di Cortesia"
        merge_commit_message        = "PR_TITLE"
        merge_commit_title          = "MERGE_MESSAGE"
        primary_language            = "Java"
        visibility                  = "public"
        template = {
          include_all_branches = false
          owner = "pagopa"
          repository = "template-payments-java-repository"
        }
      }
      protected_branches = ["main"]
      repository_secrets = [
        {
          EMD_BOT_RW_TOKEN = try(module.secrets.values["emd-bot-github-rw-TOKEN"].value, null)
          SONAR_TOKEN = try(module.secrets.values["sonar-token"].value, null)
        }
      ]
      repository_dependabot_secrets = [
        {
          EMD_BOT_RW_TOKEN = try(module.secrets.values["emd-bot-github-rw-TOKEN"].value, null)
          MIL_BOT_TOKEN = try(module.secrets.values["mil-gh-bot-token"].value, null)
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG = "pagopa"
          SONARCLOUD_PROJECT_KEY = "pagopa_emd-ar-backoffice-bff"
        }
      ]
      env_secrets = {
        envs = []
        secrets = {}
      }
      env_variables = {
        envs = []
        variables = {}
      }
    }
    "emd-ar-backoffice-fe" = {
      settings = {
        apply                       = true
        allow_forking               = true
        allow_merge_commit          = false
        allow_update_branch         = true
        description                 = "Frontend React Backoffice dell'Area Riservata di Messaggi di Cortesia"
        merge_commit_message        = "PR_TITLE"
        merge_commit_title          = "MERGE_MESSAGE"
        primary_language            = "TypeScript"
        visibility                  = "public"
      }
      protected_branches = ["main"]
      repository_secrets = [
        {
          SONAR_TOKEN = try(module.secrets.values["sonar-token"].value, null)
        }
      ]
      repository_dependabot_secrets = []
      repository_variables = [
        {
          SONARCLOUD_ORG = "pagopa"
          SONARCLOUD_PROJECT_KEY = "pagopa_emd-ar-backoffice-fe"
        }
      ]
      env_secrets = {
        envs = []
        secrets = {}
      }
      env_variables = {
        envs = []
        variables = {}
      }
    }
    "emd-message-core" = {
      settings = {
        apply                       = true
        allow_forking               = true
        allow_merge_commit          = false
        description                 = "Service which acts as dispatcher for messages to end-users through 3rd-party application"
        merge_commit_message        = "PR_TITLE"
        merge_commit_title          = "MERGE_MESSAGE"
        primary_language            = "Java"
        visibility                  = "public"
      }
      protected_branches = ["main"]
      repository_secrets = [
        {
          EMD_BOT_RW_TOKEN = try(module.secrets.values["emd-bot-github-rw-TOKEN"].value, null)
          SONAR_TOKEN = try(module.secrets.values["sonar-token"].value, null)
        }
      ]
      repository_dependabot_secrets = [
        {
          EMD_BOT_RW_TOKEN = try(module.secrets.values["emd-bot-github-rw-TOKEN"].value, null)
          MIL_BOT_TOKEN = try(module.secrets.values["mil-gh-bot-token"].value, null)
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG = "pagopa"
          SONARCLOUD_PROJECT_KEY = "pagopa_mil-message-dispatcher"
          SONARCLOUD_PROJECT_NAME = "mil-message-dispatcher"
        }
      ]
      env_secrets = {
        envs = ["github-pages"]
        secrets = {
        }
      }
      env_variables = {
        envs = ["github-pages"]
        variables = {
        }
      }
    }
    "emd-payment-core" = {
      settings = {
        apply                       = true
        allow_forking               = true
        allow_merge_commit          = false
        allow_update_branch         = true
        merge_commit_message        = "PR_TITLE"
        merge_commit_title          = "MERGE_MESSAGE"
        primary_language            = "Java"
        visibility                  = "public"
        template = {
          include_all_branches = false
          owner = "pagopa"
          repository = "template-payments-java-repository"
        }
      }
      protected_branches = ["main"]
      repository_secrets = [
        {
          EMD_BOT_RW_TOKEN = try(module.secrets.values["emd-bot-github-rw-TOKEN"].value, null)
          SONAR_TOKEN = try(module.secrets.values["sonar-token"].value, null)
        }
      ]
      repository_dependabot_secrets = [
        {
          EMD_BOT_RW_TOKEN = try(module.secrets.values["emd-bot-github-rw-TOKEN"].value, null)
          MIL_BOT_TOKEN = try(module.secrets.values["mil-gh-bot-token"].value, null)
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG = "pagopa"
          SONARCLOUD_PROJECT_KEY = "pagopa_emd-payment-core"
        }
      ]
      env_secrets = {
        envs = ["github-pages"]
        secrets = {
        }
      }
      env_variables = {
        envs = ["github-pages"]
        variables = {
        }
      }
    }
    "emd-notifier-sender" = {
      settings = {
        apply                       = true
        allow_forking               = true
        allow_merge_commit          = false
        allow_update_branch         = true
        description                 = "Service to manage messages arrived"
        merge_commit_message        = "PR_TITLE"
        merge_commit_title          = "MERGE_MESSAGE"
        primary_language            = "Java"
        visibility                  = "public"
      }
      protected_branches = ["main"]
      repository_secrets = [
        {
          EMD_BOT_RW_TOKEN = try(module.secrets.values["emd-bot-github-rw-TOKEN"].value, null)
          SONAR_TOKEN = try(module.secrets.values["sonar-token"].value, null)
        }
      ]
      repository_dependabot_secrets = [
        {
          EMD_BOT_RW_TOKEN = try(module.secrets.values["emd-bot-github-rw-TOKEN"].value, null)
          MIL_BOT_TOKEN = try(module.secrets.values["mil-gh-bot-token"].value, null)
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG = "pagopa"
          SONARCLOUD_PROJECT_KEY = "pagopa_emd-notifier-sender"
        }
      ]
      env_secrets = {
        envs = ["dev","github-pages"]
        secrets = {
        }
      }
      env_variables = {
        envs = ["dev","github-pages"]
        variables = {
        }
      }
    }
    "emd-citizen" = {
      settings = {
        apply                       = true
        allow_forking               = true
        allow_merge_commit          = false
        allow_update_branch         = true
        description                 = "Messaggi di Cortesia - Gestione dei Cittadini"
        merge_commit_message        = "PR_TITLE"
        merge_commit_title          = "MERGE_MESSAGE"
        primary_language            = "Java"
        visibility                  = "public"
      }
      protected_branches = ["main"]
      repository_secrets = [
        {
          EMD_BOT_RW_TOKEN = try(module.secrets.values["emd-bot-github-rw-TOKEN"].value, null)
          SONAR_TOKEN = try(module.secrets.values["sonar-token"].value, null)
        }
      ]
      repository_dependabot_secrets = [
        {
          EMD_BOT_RW_TOKEN = try(module.secrets.values["emd-bot-github-rw-TOKEN"].value, null)
          MIL_BOT_TOKEN = try(module.secrets.values["mil-gh-bot-token"].value, null)
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG = "pagopa"
          SONARCLOUD_PROJECT_KEY = "pagopa_emd-citizen"
        }
      ]
      env_secrets = {
        envs = ["github-pages"]
        secrets = {
        }
      }
      env_variables = {
        envs = ["github-pages"]
        variables = {
        }
      }
    }
    "emd-tpp" = {
      settings = {
        apply                       = true
        allow_forking               = true
        allow_merge_commit          = false
        description                 = "Messaggi di Cortesia - Gestione delle Terze Parti"
        merge_commit_message        = "PR_TITLE"
        merge_commit_title          = "MERGE_MESSAGE"
        primary_language            = "Java"
        visibility                  = "public"
      }
      protected_branches = ["main"]
      repository_secrets = [
        {
          EMD_BOT_RW_TOKEN = try(module.secrets.values["emd-bot-github-rw-TOKEN"].value, null)
          SONAR_TOKEN = try(module.secrets.values["sonar-token"].value, null)
        }
      ]
      repository_dependabot_secrets = [
        {
          EMD_BOT_RW_TOKEN = try(module.secrets.values["emd-bot-github-rw-TOKEN"].value, null)
          MIL_BOT_TOKEN = try(module.secrets.values["mil-gh-bot-token"].value, null)
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG = "pagopa"
          SONARCLOUD_PROJECT_KEY = "pagopa_emd-tpp"
        }
      ]
      env_secrets = {
        envs = ["github-pages"]
        secrets = {
        }
      }
      env_variables = {
        envs = ["github-pages"]
        variables = {
        }
      }
    }
    "emd-tpp" = {
      settings = {
        apply                       = true
        allow_forking               = true
        allow_merge_commit          = false
        description                 = "Messaggi di Cortesia - Gestione delle Terze Parti"
        merge_commit_message        = "PR_TITLE"
        merge_commit_title          = "MERGE_MESSAGE"
        primary_language            = "Java"
        visibility                  = "public"
      }
      protected_branches = ["main"]
      repository_secrets = [
        {
          EMD_BOT_RW_TOKEN = try(module.secrets.values["emd-bot-github-rw-TOKEN"].value, null)
          SONAR_TOKEN = try(module.secrets.values["sonar-token"].value, null)
        }
      ]
      repository_dependabot_secrets = [
        {
          EMD_BOT_RW_TOKEN = try(module.secrets.values["emd-bot-github-rw-TOKEN"].value, null)
          MIL_BOT_TOKEN = try(module.secrets.values["mil-gh-bot-token"].value, null)
        }
      ]
      repository_variables = [
        {
          SONARCLOUD_ORG = "pagopa"
          SONARCLOUD_PROJECT_KEY = "pagopa_emd-tpp"
        }
      ]
      env_secrets = {
        envs = ["github-pages"]
        secrets = {
        }
      }
      env_variables = {
        envs = ["github-pages"]
        variables = {
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
  protected_branches = ["main"]

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
  # Repositories that have main branch protected.
  # ----------------------------------------------------------------------------
  repositories_with_main_ruleset = {
    for repo_name in keys(local.repository) : repo_name => {
      include_refs = [
        for branch in ["main"] : "refs/heads/${branch}"
        if contains(local.protected_branches_by_repo[repo_name], branch)
      ]
    }
    if(contains(local.protected_branches_by_repo[repo_name], "main"))
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
  # Flattened maps for repository secrets.
  # ----------------------------------------------------------------------------
  repository_dependabot_secrets_flattened = merge([
    for repo_name, repo_data in local.repository : merge([
      for secret_map in repo_data.repository_dependabot_secrets : {
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
