resource "kubernetes_namespace" "namespace_argocd" {
  metadata {
    name = "argocd"
  }
}

locals {
  argocd_namespace = kubernetes_namespace.namespace_argocd.metadata[0].name
}

#
# Setup ArgoCD
#
resource "helm_release" "argocd" {
  name      = "argo"
  chart     = "https://github.com/argoproj/argo-helm/releases/download/argo-cd-${var.argocd_helm_release_version}/argo-cd-${var.argocd_helm_release_version}.tgz"
  namespace = local.argocd_namespace
  wait      = false

  values = [
    templatefile("argocd/argocd_helm_setup_values.yaml", {
        ARGOCD_INTERNAL_URL  = local.argocd_internal_url
        ARGOCD_TLS_CERT_NAME = replace(local.argocd_internal_url, ".", "-")
        ARGOCD_PDB_ENABLED = var.argocd_pdb_enabled
        FORCE_REINSTALL = var.argocd_force_reinstall_version
        ARGOCD_MIN_REPLICAS = var.argocd_min_replicas
        ARGOCD_MAX_REPLICAS = var.argocd_max_replicas
      }
    )
  ]

  depends_on = [
    module.aks
  ]
}

resource "null_resource" "argocd_change_admin_password" {

  triggers = {
    argocd_password = data.azurerm_key_vault_secret.argocd_admin_password.value
  }

  provisioner "local-exec" {
    command = "kubectl -n argocd patch secret argocd-secret -p '{\"stringData\": {\"admin.password\":  \"${bcrypt(data.azurerm_key_vault_secret.argocd_admin_password.value)}\", \"admin.passwordMtime\": \"'$(date +%FT%T%Z)'\"}}'"
  }
}

#
# 🛠️ Tools
#
module "argocd_workload_identity_init" {
  source = "./.terraform/modules/__v4__/kubernetes_workload_identity_init"

  workload_identity_name_prefix         = local.argocd_namespace
  workload_identity_resource_group_name = azurerm_resource_group.aks_rg.name
  workload_identity_location            = var.location
}

module "argocd_workload_identity_configuration" {
  source = "./.terraform/modules/__v4__/kubernetes_workload_identity_configuration"

  workload_identity_name_prefix         = local.argocd_namespace
  workload_identity_resource_group_name = azurerm_resource_group.aks_rg.name

  aks_name                = module.aks.name
  aks_resource_group_name = azurerm_resource_group.aks_rg.name
  namespace               = local.argocd_namespace

  key_vault_id                      = data.azurerm_key_vault.kv_core.id
  key_vault_certificate_permissions = ["Get"]
  key_vault_key_permissions         = ["Get"]
  key_vault_secret_permissions      = ["Get"]

  depends_on = [module.argocd_workload_identity_init]
}

module "cert_mounter_argocd_internal" {
  source = "./.terraform/modules/__v4__/cert_mounter"

  namespace        = local.argocd_namespace
  certificate_name = replace(local.argocd_internal_url, ".", "-")
  kv_name          = data.azurerm_key_vault.kv_core.name
  tenant_id        = data.azurerm_subscription.current.tenant_id

  workload_identity_service_account_name = module.argocd_workload_identity_configuration.workload_identity_service_account_name
  workload_identity_client_id            = module.argocd_workload_identity_configuration.workload_identity_client_id

  depends_on = [
    module.argocd_workload_identity_configuration
  ]
}

resource "helm_release" "reloader_argocd" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = "v1.0.30"
  namespace  = local.argocd_namespace

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
}
