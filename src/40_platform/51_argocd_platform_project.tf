locals {
  argocd_project_name = "${var.domain}-project"

  ### ArgoCD Groups ---------------------------------------------
  argocd_groups_admin =  [
    data.azuread_group.adgroup_admin.object_id,
  ]

  argocd_groups_developer = [
    data.azuread_group.adgroup_developers.object_id,
  ]
}

#-------------------------------------------------------------------------
# Terraform argocd project
#-------------------------------------------------------------------------
resource "argocd_project" "platform_project" {
  metadata {
    name      = local.argocd_project_name
    namespace = local.argocd_namespace
    labels = {
      acceptance = "true"
    }
  }

  spec {
    description = local.argocd_project_name

    source_namespaces = local.argocd_project_namespaces
    source_repos      = ["*"]

    dynamic "destination" {
      for_each = toset(local.argocd_project_namespaces)
      content {
        server    = "https://kubernetes.default.svc"
        namespace = destination.value
      }
    }

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
      groups = []
      policies = [
        "p, proj:${local.argocd_project_name}:reader, applications, get, ${local.argocd_project_name}/*, allow",
        "p, proj:${local.argocd_project_name}:reader, logs, get, ${local.argocd_project_name}/*, allow",
      ]
    }

    role {
      name   = "external"
      groups = []
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
