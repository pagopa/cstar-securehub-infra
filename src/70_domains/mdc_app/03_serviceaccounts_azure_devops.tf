# 🔒 Secret Devops

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "aks_apiserver_url" {
  name         = "${local.aks_name}-apiserver-url"
  value        = "https://${data.azurerm_kubernetes_cluster.aks.private_fqdn}:443"
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_domain.id

  tags = local.tags
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "azure_devops_sa_token" {
  depends_on   = [module.kubernetes_service_account]
  name         = "${local.aks_name}-azure-devops-sa-token"
  value        = module.kubernetes_service_account.sa_token # base64 value
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_domain.id

  tags = local.tags
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "azure_devops_sa_cacrt" {
  depends_on   = [module.kubernetes_service_account]
  name         = "${local.aks_name}-azure-devops-sa-cacrt"
  value        = module.kubernetes_service_account.sa_ca_cert # base64 value
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_domain.id

  tags = local.tags
}

module "kubernetes_service_account" {
  source    = "./.terraform/modules/__v4__/kubernetes_service_account"
  name      = "azure-devops"
  namespace = "${var.domain}-system"
}

#--------------------------------------------------------------------------------------------------

resource "kubernetes_role_binding" "deployer_binding" {
  metadata {
    name      = "deployer-binding"
    namespace = var.domain
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-deployer"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "azure-devops"
    namespace = "${var.domain}-system"
  }
}

resource "kubernetes_role_binding" "system_deployer_binding" {
  metadata {
    name      = "system-deployer-binding"
    namespace = "${var.domain}-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system-cluster-deployer"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "azure-devops"
    namespace = "${var.domain}-system"
  }
}
