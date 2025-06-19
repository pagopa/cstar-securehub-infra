resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = "keycloak"
  }
}

locals {
  keycloak_namespace = kubernetes_namespace.keycloak.metadata[0].name
}


module "workload_identity_configuration_platform_coder_keycloak" {
  source = "./.terraform/modules/__v4__/kubernetes_workload_identity_configuration"

  workload_identity_name_prefix         = "platform-coder"
  workload_identity_resource_group_name = data.azurerm_kubernetes_cluster.aks.resource_group_name
  aks_name                              = data.azurerm_kubernetes_cluster.aks.name
  aks_resource_group_name               = data.azurerm_kubernetes_cluster.aks.resource_group_name
  namespace                             = local.keycloak_namespace

  key_vault_id                      = data.azurerm_key_vault.key_vault_core.id
  key_vault_certificate_permissions = ["Get"]
  key_vault_key_permissions         = ["Get"]
  key_vault_secret_permissions      = ["Get"]

  depends_on = [
    module.workload_identity_platform_coder,
  ]
}

### Cert Mounter
module "cert_mounter" {
  source = "./.terraform/modules/__v4__/cert_mounter"

  namespace        = local.keycloak_namespace
  certificate_name = replace(local.keycloak_ingress_hostname, ".", "-")
  kv_name          = data.azurerm_key_vault.key_vault_core.name
  tenant_id        = data.azurerm_subscription.current.tenant_id

  workload_identity_service_account_name = module.workload_identity_configuration_platform_coder_keycloak.workload_identity_service_account_name
  workload_identity_client_id            = module.workload_identity_configuration_platform_coder_keycloak.workload_identity_client_id

  affinity = jsonencode({
    nodeAffinity = {
      requiredDuringSchedulingIgnoredDuringExecution = {
        nodeSelectorTerms = [{
          matchExpressions = [
            {
              key      = "node_type"
              operator = "In"
              values   = ["user"]
            }
          ]
        }]
      }
    }
    podAntiAffinity = {
      preferredDuringSchedulingIgnoredDuringExecution = [{
        weight = 100
        podAffinityTerm = {
          namespaces  = [local.keycloak_namespace]
          topologyKey = "topology.kubernetes.io/zone"
          labelSelector = {
            matchLabels = {
              "app.kubernetes.io/instance" = "cert-mounter-blueprint"
            }
          }
        }
      }]
    }
  })
}

# Reloader
resource "helm_release" "reloader" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = "v1.0.30"
  namespace  = local.keycloak_namespace

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
}
