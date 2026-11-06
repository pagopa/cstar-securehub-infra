locals {
  listmonk_argocd_hostname = "argocd.${var.location_short}.${var.dns_zone_internal_prefix}.${var.prefix}.${var.external_domain}"
  listmonk_helm_repository = "https://repo.helmforge.dev"
}

# Same control plane and credential source as src/40_platform.
data "azurerm_key_vault" "listmonk_cicd" {
  name                = "${local.product_nodomain}-cicd-kv"
  resource_group_name = "${local.product_nodomain}-core-sec-rg"
}

data "azurerm_key_vault_secret" "listmonk_argocd_username" {
  name         = "argocd-admin-username"
  key_vault_id = data.azurerm_key_vault.listmonk_cicd.id
}

data "azurerm_key_vault_secret" "listmonk_argocd_password" {
  name         = "argocd-admin-password"
  key_vault_id = data.azurerm_key_vault.listmonk_cicd.id
}

resource "argocd_project" "listmonk" {
  metadata {
    name      = "listmonk-project"
    namespace = "argocd"
  }

  spec {
    description       = "Listmonk platform workload; infrastructure and secrets remain Terraform-owned"
    source_namespaces = ["argocd"]
    source_repos      = [local.listmonk_helm_repository]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = local.listmonk_namespace
    }

    cluster_resource_blacklist {
      group = "*"
      kind  = "*"
    }

    dynamic "namespace_resource_whitelist" {
      for_each = {
        Deployment            = "apps"
        Service               = ""
        PersistentVolumeClaim = ""
        Ingress               = "networking.k8s.io"
      }
      content {
        group = namespace_resource_whitelist.value
        kind  = namespace_resource_whitelist.key
      }
    }

    role {
      name   = "admin"
      groups = [data.azuread_group.adgroup_admin.object_id]
      policies = [
        "p, proj:listmonk-project:admin, applications, *, listmonk-project/*, allow",
        "p, proj:listmonk-project:admin, logs, get, listmonk-project/*, allow",
      ]
    }
  }
}

resource "argocd_application" "listmonk" {
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
    project = argocd_project.listmonk.metadata[0].name

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
    azurerm_private_dns_a_record.listmonk,
  ]
}
