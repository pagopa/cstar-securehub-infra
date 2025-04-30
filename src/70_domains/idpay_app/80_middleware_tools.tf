### Cert Mounter
module "cert_mounter" {
  source = "./.terraform/modules/__v4__/cert_mounter"

  namespace        = var.domain
  certificate_name = replace(var.ingress_domain_hostname, ".", "-")
  kv_name          = data.azurerm_key_vault.key_vault_domain.name
  tenant_id        = data.azurerm_subscription.current.tenant_id

  workload_identity_service_account_name = data.azurerm_key_vault_secret.workload_identity_service_account_name.value
  workload_identity_client_id            = data.azurerm_key_vault_secret.workload_identity_client_id.value
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
          namespaces  = [var.domain]
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
  namespace  = var.domain

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
}
