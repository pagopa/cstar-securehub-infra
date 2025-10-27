locals {
  influxdb_enabled = var.env != "prod"
}

resource "kubernetes_namespace" "influxdb_namespace" {
  count = local.influxdb_enabled ? 1 : 0

  metadata {
    name = "platform-influxdb"
  }
}

locals {
  influxdb_namespace      = try(kubernetes_namespace.influxdb_namespace[0].metadata[0].name, null)
  influxdb_admin_username = "admin"
  influxdb_admin_password = try(random_password.influxdb_admin_password[0].result, null)
  influxdb_admin_token    = try(random_password.influxdb_admin_token[0].result, null)
}

#-------------------------------------------------------------------------
# password and token generation
#-------------------------------------------------------------------------
resource "random_password" "influxdb_admin_password" {
  count   = local.influxdb_enabled ? 1 : 0
  length  = 33
  special = false
}

resource "random_password" "influxdb_admin_token" {
  count   = local.influxdb_enabled ? 1 : 0
  length  = 33
  special = false
}

resource "azurerm_key_vault_secret" "influxdb_admin_username" {
  count        = local.influxdb_enabled ? 1 : 0
  name         = "influxdb-admin-username"
  key_vault_id = data.azurerm_key_vault.cicd_kv.id
  value        = local.influxdb_admin_username

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "influxdb_admin_password" {
  count        = local.influxdb_enabled ? 1 : 0
  name         = "influxdb-admin-password"
  key_vault_id = data.azurerm_key_vault.cicd_kv.id
  value        = local.influxdb_admin_password

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "influxdb_admin_token" {
  count        = local.influxdb_enabled ? 1 : 0
  name         = "influxdb-admin-token"
  key_vault_id = data.azurerm_key_vault.cicd_kv.id
  value        = local.influxdb_admin_token

  tags = module.tag_config.tags
}

#-------------------------------------------------------------------------
# 📦 ArgoCD Application - InfluxDB2
#-------------------------------------------------------------------------
resource "argocd_application" "influxdb2" {
  count = local.influxdb_enabled ? 1 : 0

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
        values = templatefile("${path.module}/aks/influxdb/values.yaml", {
          repository      = var.influxdb2_helm.image.name
          tag             = var.influxdb2_helm.image.tag
          hostname        = local.influxdb_internal_url
          tls_secret_name = replace(local.influxdb_internal_url, ".", "-")
          tolerations     = try(var.influxdb2_helm.tolerations, [])
          affinity        = try(var.influxdb2_helm.affinity, {})
          admin_user = {
            username = local.influxdb_admin_username
            password = local.influxdb_admin_password
            token    = local.influxdb_admin_token
          }
        })
      }
    }
  }

  depends_on = [
    argocd_project.platform_project,
    module.argocd
  ]
}

#-------------------------------------------------------------------------------
# 🌐 Network
#-------------------------------------------------------------------------------
resource "azurerm_private_dns_a_record" "influxdb_ingress" {
  count               = local.influxdb_enabled ? 1 : 0
  name                = "influxdb.itn"
  zone_name           = data.azurerm_private_dns_zone.internal.name
  resource_group_name = data.azurerm_private_dns_zone.internal.resource_group_name
  ttl                 = 3600
  records             = [var.ingress_load_balancer_ip]

  tags = module.tag_config.tags
}

#---------------------------------------------------------------
# tools
#---------------------------------------------------------------

module "influxdb_cert_mounter_workload_identity_init" {
  count  = local.influxdb_enabled ? 1 : 0
  source = "./.terraform/modules/__v4__/kubernetes_workload_identity_init"

  workload_identity_name_prefix         = "influxdb-cert-mounter"
  workload_identity_resource_group_name = data.azurerm_kubernetes_cluster.aks.resource_group_name
  workload_identity_location            = var.location

  depends_on = [
    argocd_application.influxdb2
  ]
}

module "influxdb_cert_mounter_workload_identity_configuration" {
  count  = local.influxdb_enabled ? 1 : 0
  source = "./.terraform/modules/__v4__/kubernetes_workload_identity_configuration"

  workload_identity_name_prefix         = "influxdb-cert-mounter"
  workload_identity_resource_group_name = data.azurerm_kubernetes_cluster.aks.resource_group_name
  aks_name                              = data.azurerm_kubernetes_cluster.aks.name
  aks_resource_group_name               = data.azurerm_kubernetes_cluster.aks.resource_group_name
  namespace                             = local.influxdb_namespace

  key_vault_id                      = data.azurerm_key_vault.core_kv.id
  key_vault_certificate_permissions = ["Get"]
  key_vault_key_permissions         = ["Get"]
  key_vault_secret_permissions      = ["Get"]

  depends_on = [
    argocd_application.influxdb2,
    module.influxdb_cert_mounter_workload_identity_init
  ]

}

module "influxdb_cert_mounter_internal_domain_certificate" {
  count            = local.influxdb_enabled ? 1 : 0
  source           = "./.terraform/modules/__v4__/cert_mounter"
  namespace        = local.influxdb_namespace
  certificate_name = replace(local.influxdb_internal_url, ".", "-")
  kv_name          = data.azurerm_key_vault.core_kv.name
  tenant_id        = data.azurerm_subscription.current.tenant_id

  workload_identity_service_account_name = module.influxdb_cert_mounter_workload_identity_configuration[count.index].workload_identity_service_account_name
  workload_identity_client_id            = module.influxdb_cert_mounter_workload_identity_configuration[count.index].workload_identity_client_id

  depends_on = [
    argocd_application.influxdb2,
    module.influxdb_cert_mounter_workload_identity_configuration
  ]
}

resource "helm_release" "reloader_influxdb" {
  count      = local.influxdb_enabled ? 1 : 0
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = "v1.0.30"
  namespace  = local.influxdb_namespace

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
}
