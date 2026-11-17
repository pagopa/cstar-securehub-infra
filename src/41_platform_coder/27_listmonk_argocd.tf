locals {
  listmonk_helm_repository = "https://repo.helmforge.dev"
}

resource "argocd_application" "listmonk" {
  count = local.listmonk_enabled ? 1 : 0
  metadata {
    name      = "listmonk"
    namespace = "argocd"
    labels = {
      name   = "listmonk"
      domain = var.domain
      area   = "platform"
    }
  }

  # Creating the Application must not wait for an intentionally manual first sync.
  wait = false

  spec {
    # Managed by src/40_platform; deploy its destination update first.
    project = "platform-project"

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = local.listmonk_namespace
    }

    source {
      repo_url        = local.listmonk_helm_repository
      target_revision = var.listmonk_configuration.chart_version
      chart           = "listmonk"
      helm {
        release_name     = "listmonk"
        values           = local.listmonk_helm_values
        pass_credentials = false
        skip_crds        = true
      }
    }

    # Manual sync: review schema upgrades and the upstream rolling strategy first.
    sync_policy {
      sync_options = ["FailOnSharedResource=true"]
    }
  }

  depends_on = [
    postgresql_grant.listmonk_database,
    postgresql_grant.listmonk_schema,
    postgresql_extension.listmonk_pgcrypto,
    kubernetes_secret.listmonk_db,
    kubernetes_secret.listmonk_bootstrap,
    module.listmonk_cert_mounter,
    helm_release.reloader_listmonk,
    azurerm_private_dns_a_record.listmonk,
  ]
}
