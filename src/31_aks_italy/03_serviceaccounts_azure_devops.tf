resource "kubernetes_namespace" "system_domain_namespace" {
  metadata {
    name = "${var.domain}-system"
  }
}

resource "kubernetes_namespace" "domain_namespace" {
  metadata {
    name = var.domain
  }
}

module "kubernetes_service_account" {
  source = "./.terraform/modules/__v4__/kubernetes_service_account"

  name      = "azure-devops"
  namespace = kubernetes_namespace.system_domain_namespace.metadata[0].name
}

#-------------------------------------------------------------

resource "kubernetes_role_binding" "deployer_binding" {
  for_each = toset([var.domain, kubernetes_namespace.namespace_argocd.metadata[0].name, kubernetes_namespace.ingress.metadata[0].name, kubernetes_namespace.monitoring.metadata[0].name])

  metadata {
    name      = "deployer-binding"
    namespace = each.key
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-deployer"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "azure-devops"
    namespace = kubernetes_namespace.system_domain_namespace.metadata[0].name
  }
}

resource "kubernetes_role_binding" "system_deployer_binding" {
  metadata {
    name      = "system-deployer-binding"
    namespace = kubernetes_namespace.system_domain_namespace.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system-cluster-deployer"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "azure-devops"
    namespace = kubernetes_namespace.system_domain_namespace.metadata[0].name
  }
}

resource "kubernetes_role_binding" "kube_system_reader_binding" {
  metadata {
    name      = "kube-system-reader-${var.domain}"
    namespace = "kube-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "kube-system-reader"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "azure-devops"
    namespace = kubernetes_namespace.system_domain_namespace.metadata[0].name
  }
}


#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "azure_devops_sa_token" {
  depends_on   = [module.kubernetes_service_account]
  name         = "${local.aks_name}-azure-devops-sa-token"
  value        = module.kubernetes_service_account.sa_token
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_core.id
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "azure_devops_sa_cacrt" {
  depends_on   = [module.kubernetes_service_account]
  name         = "${local.aks_name}-azure-devops-sa-cacrt"
  value        = module.kubernetes_service_account.sa_ca_cert
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_core.id
}

resource "azurerm_key_vault_secret" "aks_apiserver_url" {
  name         = "${local.aks_name}-apiserver-url"
  value        = "https://${local.aks_api_url}:443"
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_core.id
}
