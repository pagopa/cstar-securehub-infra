locals {
  argocd_applications = {
    "top" = {
      "idpay-onboarding-workflow" = {
        name          = "idpay-onboarding-workflow"
        target_branch = "main"
      },
    }
    "mid" = {
    }
    "ext" = {
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
