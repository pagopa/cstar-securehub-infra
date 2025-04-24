#
# Terraform argocd project
#
resource "argocd_project" "domain_project" {
  metadata {
    name      = "${var.domain}-project"
    namespace = local.argocd_namespace
    labels = {
      acceptance = "true"
    }
  }

  spec {
    description = "${var.domain}-project"

    source_namespaces = ["batch"]
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

    #     role {
    #       name = "anotherrole"
    #       policies = [
    #         "p, proj:myproject:testrole, applications, get, myproject/*, allow",
    #         "p, proj:myproject:testrole, applications, sync, myproject/*, deny",
    #       ]
    #     }
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
