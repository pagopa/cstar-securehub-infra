resource "kubernetes_namespace" "influxdb_namespace" {
  metadata {
    name = "platform-influxdb"
  }
}

locals {
  influxdb_namespace = kubernetes_namespace.influxdb_namespace.metadata[0].name
}

#-------------------------------------------------------------------------
# password and token generation
#-------------------------------------------------------------------------
resource "random_password" "influxdb_admin_password" {
  length  = 24
  special = true
}

resource "random_password" "influxdb_admin_token" {
  length  = 40
  special = false
}

resource "azurerm_key_vault_secret" "influxdb_admin_username" {
  name         = "influxdb-admin-username"
  key_vault_id = data.azurerm_key_vault.core_kv.id
  value =  "admin"

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "influxdb_admin_password" {
  name         = "influxdb-admin-password"
  key_vault_id = data.azurerm_key_vault.core_kv.id
  value        = random_password.influxdb_admin_password.result

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "influxdb_admin_token" {
  name         = "influxdb-admin-token"
  key_vault_id = data.azurerm_key_vault.core_kv.id
  value        = random_password.influxdb_admin_token.result

  tags = module.tag_config.tags
}

#-------------------------------------------------------------------------
# 📦 ArgoCD Application - InfluxDB2
#-------------------------------------------------------------------------
resource "argocd_application" "influxdb2" {
  count = var.env_short != "p" ? 1 : 0

  metadata {
    name      = "influxdb2"
    namespace = local.influxdb_namespace
    labels = {
      name   = "influxdb2"
      domain = var.domain
      class  = "observability"
      area   = var.domain
    }
  }

  spec {
    project = argocd_project.platform_project.metadata[0].name

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = local.influxdb_namespace
    }

    source {
      repo_url        = "https://helm.influxdata.com/"
      chart           = "influxdb2"
      target_revision = var.influxdb2_helm.chart_version

      helm {
        release_name = "influxdb2"
        values = yamlencode(templatefile("${path.module}/aks/influxdb/values.yaml", {
          repository  = var.influxdb2_helm.image.name
          tag         = var.influxdb2_helm.image.tag
          hostname    = local.influxdb_url
          # tolerations = try(var.influxdb2_helm.tolerations, [])
          # affinity    = try(var.influxdb2_helm.affinity, {})
          # admin_user = {
          #   username = azurerm_key_vault_secret.influxdb_admin_username.value
          #   password = random_password.influxdb_admin_password.result
          #   token    = random_password.influxdb_admin_token.result
          # }
        }))
      }
    }
  }
}
