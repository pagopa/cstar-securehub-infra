locals {
  argocd_project_name = "${var.domain}-project"

  ### ArgoCD Groups ---------------------------------------------
  argocd_groups_admin = var.env == "prod" ? [
    data.azuread_group.adgroup_idpay_admin.object_id,
    data.azuread_group.adgroup_idpay_oncall[0].object_id
  ] : [
    data.azuread_group.adgroup_admin.object_id,
  ]

  argocd_groups_developer = [
    data.azuread_group.adgroup_idpay_developers.object_id,
  ] 

  argocd_groups_reader = var.env == "prod" ? [
    data.azuread_group.adgroup_idpay_project_managers[0].object_id,
  ] : []

  argocd_groups_external = [
    data.azuread_group.adgroup_idpay_externals.object_id,
  ]
}

#
# Terraform argocd project
#
resource "argocd_project" "domain_project" {
  metadata {
    name      = local.argocd_project_name
    namespace = local.argocd_namespace
    labels = {
      acceptance = "true"
    }
  }

  spec {
    description = local.argocd_project_name

    source_namespaces = [var.domain]
    source_repos      = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.domain
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = local.argocd_namespace
    }

    #     cluster_resource_blacklist {
    #       group = "*"
    #       kind  = "*"
    #     }

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    namespace_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    orphaned_resources {
      warn = true
    }


    # ──────────────────── ROLES ───────────────────────
    # Admin → pieno controllo + modifica AppProject
    role {
      name   = "admin"
      groups = local.argocd_groups_admin
      policies = [
        "p, proj:${local.argocd_project_name}:admin, applications, *, ${local.argocd_project_name}/*, allow",
        "p, proj:${local.argocd_project_name}:admin, applicationsets, *, ${local.argocd_project_name}/*, allow",
        "p, proj:${local.argocd_project_name}:admin, logs, get, ${local.argocd_project_name}/*, allow",
        "p, proj:${local.argocd_project_name}:admin, exec, create, ${local.argocd_project_name}/*, allow",
      ]
    }

    role {
      name   = "developer"
      groups = local.argocd_groups_developer
      policies = [
        "p, proj:${local.argocd_project_name}:developer, applications, get, ${local.argocd_project_name}/*, allow",
        "p, proj:${local.argocd_project_name}:developer, applications, create, ${local.argocd_project_name}/*, allow",
        "p, proj:${local.argocd_project_name}:developer, applications, update, ${local.argocd_project_name}/*, allow",
        "p, proj:${local.argocd_project_name}:developer, applications, delete, ${local.argocd_project_name}/*, allow",
        "p, proj:${local.argocd_project_name}:developer, applications, sync, ${local.argocd_project_name}/*, allow",
        "p, proj:${local.argocd_project_name}:developer, applicationsets, *, ${local.argocd_project_name}/*, allow",
        "p, proj:${local.argocd_project_name}:developer, logs, get, ${local.argocd_project_name}/*, allow",
      ]
    }

    role {
      name   = "reader"
      groups = local.argocd_groups_reader
      policies = [
        "p, proj:${local.argocd_project_name}:reader, applications, get, ${local.argocd_project_name}/*, allow",
        "p, proj:${local.argocd_project_name}:reader, logs, get, ${local.argocd_project_name}/*, allow",
      ]
    }

    role {
      name   = "external"
      groups = local.argocd_groups_external
      policies = [
        "p, proj:${local.argocd_project_name}:external, applications, get, ${local.argocd_project_name}/*, allow",
        "p, proj:${local.argocd_project_name}:external, logs, get, ${local.argocd_project_name}/*, allow",
        "p, proj:${local.argocd_project_name}:external, applications, delete/*/Pod/*/*, ${local.argocd_project_name}/*, allow",
        "p, proj:${local.argocd_project_name}:external, applications, action/apps/Deployment/restart, ${local.argocd_project_name}/*, allow",
        "p, proj:${local.argocd_project_name}:external, applications, action/apps/StatefulSet/restart, ${local.argocd_project_name}/*, allow",
        "p, proj:${local.argocd_project_name}:external, applications, action/apps/DaemonSet/restart, ${local.argocd_project_name}/*, allow",
        "p, proj:${local.argocd_project_name}:external, applications, sync, ${local.argocd_project_name}/*, allow",
      ]
    }

  }
}

#
# 🔒 secrets
#
resource "azurerm_key_vault_secret" "argocd_server_url" {
  name         = "argocd-server-url"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
  value        = local.argocd_internal_url
}
