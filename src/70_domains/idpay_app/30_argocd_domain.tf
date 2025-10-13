locals {
  argocd_applications = {
    "top" = {
      "idpay-onboarding-workflow" = {
        name          = "idpay-onboarding-workflow"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-payment" = {
        name          = "idpay-payment"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-wallet" = {
        name          = "idpay-wallet"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-reward-calculator" = {
        name          = "idpay-reward-calculator"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-merchant" = {
        name          = "idpay-merchant"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-admissibility-assessor" = {
        name          = "idpay-admissibility-assessor"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-transactions" = {
        name          = "idpay-transactions"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-portal-welfare-backend-initiative" = {
        name          = "idpay-portal-welfare-backend-initiative"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-kafka-connect" = {
        name          = "idpay-kafka-connect"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-asset-register-backend" = {
        name          = "idpay-asset-register-backend"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-ranker" = {
        name          = "idpay-ranker"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "mcshared-datavault" = {
        name          = "mcshared-datavault"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      }
      "fake-mcshared-datavault" = {
        name          = "fake-mcshared-datavault"
        target_branch = "IDP-2806-idpay-duplicazione-mcshared-per-test-con-shared-key-su-nuova-collection"
        env           = ["dev", "uat", "prod"]
      }
    }
    "mid" = {
      "idpay-group" = {
        name          = "idpay-group"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-initiative-statistics" = {
        name          = "idpay-initiative-statistics"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-payment-instrument" = {
        name          = "idpay-payment-instrument"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-portal-welfare-backend-role-permission" = {
        name          = "idpay-portal-welfare-backend-role-permission"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-ranking" = {
        name          = "idpay-ranking"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-recovery-error-topic" = {
        name          = "idpay-recovery-error-topic"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-reward-notification" = {
        name          = "idpay-reward-notification"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-reward-user-id-splitter" = {
        name          = "idpay-reward-user-id-splitter"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-timeline" = {
        name          = "idpay-timeline"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      }
    }
    "ext" = {
      "idpay-iban" = {
        name          = "idpay-iban"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-notification-email" = {
        name          = "idpay-notification-email"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-notification-manager" = {
        name          = "idpay-notification-manager"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-self-expense-backend" = {
        name          = "idpay-self-expense-backend"
        target_branch = "main"
        env           = ["dev", "uat", "prod"]
      },
      "idpay-mock" = {
        name          = "idpay-mock"
        target_branch = "main"
        env           = ["dev", "uat"]
      }
    }
  }

  # FLATTEN con FILTRO su env
  flattened_applications = merge([
    for class, apps in local.argocd_applications : {
      for app_name, app in apps :
      app_name => merge(app, { class = class })
      if contains(app.env, var.env)
    }
  ]...)
}

resource "argocd_application" "domain_argocd_applications" {
  for_each = local.flattened_applications

  metadata {
    name      = each.value.name
    namespace = var.domain
    labels = {
      name   = each.value.name
      domain = var.domain
      class  = each.value.class
      area   = var.domain
    }
  }

  spec {
    project = local.argocd_domain_project_name

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.domain
    }

    source {
      repo_url        = "https://github.com/pagopa/idpay-deploy-aks"
      target_revision = can(each.value.target_branch) ? each.value.target_branch : "main"
      path            = "helm/${var.env}/${each.value.class}/${each.value.name}"

      helm {
        values = yamlencode({
          microservice-chart : {
            azure : {
              workloadIdentityClientId : data.azurerm_key_vault_secret.workload_identity_client_id.value
            }
            serviceAccount : {
              name : data.azurerm_key_vault_secret.workload_identity_service_account_name.value
            }
          }
        })
        value_files                = ["../../../_global/${each.value.name}.yaml"]
        ignore_missing_value_files = false
        pass_credentials           = false
        skip_crds                  = false
      }
    }

    sync_policy {
      # sync_options = []
      #
      # automated {
      #   allow_empty = false
      #   prune       = false
      #   self_heal   = false
      # }
      #
      # retry {
      #   limit = "5"
      #
      #   backoff {
      #     duration     = "5s"
      #     factor       = "2"
      #     max_duration = "3m0s"
      #   }
      # }
    }

    ignore_difference {
      group         = "apps"
      kind          = "Deployment"
      json_pointers = ["/spec/replicas"]
    }
  }
}
