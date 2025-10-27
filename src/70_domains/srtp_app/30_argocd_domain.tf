locals {
  argocd_applications = {
    "top" = merge(
      {
        "rtp-activator" = {
          name          = "rtp-activator"
          target_branch = "main"
          env           = ["dev", "uat", "prod"]
        }
      },
      {
        "rtp-sender" = {
          name          = "rtp-sender"
          target_branch = "SRTP-1069-add-helm-to-rtp-sender"
          env           = ["dev", "uat", "prod"]
        }
      }
    )
    "mid" = {}
    "ext" = {}
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
    project = "${var.domain}-project"

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.domain
    }

    source {
      repo_url        = "https://github.com/pagopa/${var.domain}-deploy-aks"
      target_revision = "SRTP-1069-add-helm-to-rtp-sender"
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
