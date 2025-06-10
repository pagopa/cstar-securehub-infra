locals {
  argocd_applications = {
    "top" = {
      "idpay-onboarding-workflow" = {
        name          = "idpay-onboarding-workflow"
        target_branch = "main"
      },
      "idpay-payment" = {
        name          = "idpay-payment"
        target_branch = "main"
      },
      "idpay-wallet" = {
        name          = "idpay-wallet"
        target_branch = "main"
      },
      "idpay-reward-calculator" = {
        name          = "idpay-reward-calculator"
        target_branch = "main"
      },
      "idpay-merchant" = {
        name          = "idpay-merchant"
        target_branch = "main"
      },
      "idpay-admissibility-assessor" = {
        name          = "idpay-admissibility-assessor"
        target_branch = "main"
      },
      "idpay-transactions" = {
        name          = "idpay-transactions"
        target_branch = "main"
      },
      "idpay-portal-welfare-backend-initiative" = {
        name          = "idpay-portal-welfare-backend-initiative"
        target_branch = "main"
      },
      "idpay-kafka-connect" = {
        name          = "idpay-kafka-connect"
        target_branch = "main"
      },
      "idpay-keycloak" = {
        name          = "idpay-keycloak"
        target_branch = "main"
      }
    }
    "mid" = {
      "idpay-group" = {
        name          = "idpay-group"
        target_branch = "main"
      },
      "idpay-initiative-statistics" = {
        name          = "idpay-initiative-statistics"
        target_branch = "main"
      },
      "idpay-payment-instrument" = {
        name          = "idpay-payment-instrument"
        target_branch = "main"
      },
      "idpay-portal-welfare-backend-role-permission" = {
        name          = "idpay-portal-welfare-backend-role-permission"
        target_branch = "main"
      },
      "idpay-ranking" = {
        name          = "idpay-ranking"
        target_branch = "main"
      },
      "idpay-recovery-error-topic" = {
        name          = "idpay-recovery-error-topic"
        target_branch = "main"
      },
      " idpay-reward-notification" = {
        name          = "idpay-reward-notification"
        target_branch = "main"
      },
      "idpay-reward-user-id-splitter" = {
        name          = "idpay-reward-user-id-splitter"
        target_branch = "main"
      },
      "idpay-timeline" = {
        name          = "idpay-timeline"
        target_branch = "main"
      },
    }
    "ext" = {
      "idpay-iban" = {
        name          = "idpay-iban"
        target_branch = "main"
      },
      "idpay-notification-email" = {
        name          = "idpay-notification-email"
        target_branch = "main"
      },
      "idpay-notification-manager" = {
        name          = "idpay-notification-manager"
        target_branch = "main"
      },
      "idpay-self-expense-backend" = {
        name          = "idpay-self-expense-backend"
        target_branch = "main"
      },
      "idpay-mock" = {
        name          = "idpay-mock"
        target_branch = "main"
      }
    }
  }
  flattened_applications = merge([
    for class, apps in local.argocd_applications : {
      for app_name, app in apps : app_name => merge(app, {
        class = class
      })
    }
  ]...)
}


#
# APPS
#
resource "argocd_application" "domain_argocd_applications" {
  for_each = local.flattened_applications

  metadata {
    name      = each.value.name
    namespace = local.argocd_namespace
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
      namespace = local.argocd_namespace
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

    # Sync policy configuration
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

#
# 🔒 secrets
#
resource "azurerm_key_vault_secret" "argocd_server_url" {
  name         = "argocd-server-url"
  key_vault_id = data.azurerm_key_vault.key_vault_domain.id
  value        = local.argocd_internal_url
}
