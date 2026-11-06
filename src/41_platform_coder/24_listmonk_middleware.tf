resource "kubernetes_namespace" "listmonk" {
  metadata {
    name = "listmonk"
  }
}

locals {
  listmonk_namespace = kubernetes_namespace.listmonk.metadata[0].name
}

module "workload_identity_platform_coder_listmonk" {
  source = "./.terraform/modules/__v4__/kubernetes_workload_identity_init"

  workload_identity_name_prefix         = "platform-coder-listmonk"
  workload_identity_resource_group_name = data.azurerm_kubernetes_cluster.aks.resource_group_name
  workload_identity_location            = var.location
  tags                                  = module.tag_config.tags
}

module "workload_identity_configuration_platform_coder_listmonk" {
  source = "./.terraform/modules/__v4__/kubernetes_workload_identity_configuration"

  workload_identity_name_prefix         = "platform-coder-listmonk"
  workload_identity_resource_group_name = data.azurerm_kubernetes_cluster.aks.resource_group_name
  aks_name                              = data.azurerm_kubernetes_cluster.aks.name
  aks_resource_group_name               = data.azurerm_kubernetes_cluster.aks.resource_group_name
  namespace                             = local.listmonk_namespace

  key_vault_id                      = data.azurerm_key_vault.key_vault_core.id
  key_vault_certificate_permissions = ["Get"]
  key_vault_key_permissions         = ["Get"]
  key_vault_secret_permissions      = ["Get"]
  tags                              = module.tag_config.tags

  depends_on = [module.workload_identity_platform_coder_listmonk]
}

module "listmonk_cert_mounter" {
  source = "./.terraform/modules/__v4__/cert_mounter"

  namespace        = local.listmonk_namespace
  certificate_name = replace(local.listmonk_ingress_hostname, ".", "-")
  kv_name          = data.azurerm_key_vault.key_vault_core.name
  tenant_id        = data.azurerm_subscription.current.tenant_id

  workload_identity_service_account_name = module.workload_identity_configuration_platform_coder_listmonk.workload_identity_service_account_name
  workload_identity_client_id            = module.workload_identity_configuration_platform_coder_listmonk.workload_identity_client_id

  affinity = jsonencode({
    nodeAffinity = {
      requiredDuringSchedulingIgnoredDuringExecution = {
        nodeSelectorTerms = [{
          matchExpressions = [{
            key      = "node_type"
            operator = "In"
            values   = ["user"]
          }]
        }]
      }
    }
    podAntiAffinity = {
      preferredDuringSchedulingIgnoredDuringExecution = [{
        weight = 100
        podAffinityTerm = {
          namespaces  = [local.listmonk_namespace]
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

  # The service-account output alone does not depend on KV access or federation.
  depends_on = [module.workload_identity_configuration_platform_coder_listmonk]
}
