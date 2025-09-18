resource "kubernetes_namespace" "namespace_argocd" {
  metadata {
    name = "argocd"
  }
}

#
# Setup ArgoCD (module)
#
module "argocd" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//kubernetes_argocd_setup?ref=PAYMCLOUD-231-argocd-creazione-modulo"

  namespace                             = kubernetes_namespace.namespace_argocd.metadata[0].name
  argocd_helm_release_version           = var.argocd_helm_release_version
  argocd_application_namespaces         = var.argocd_application_namespaces
  argocd_force_reinstall_version        = var.argocd_force_reinstall_version
  tenant_id                             = data.azurerm_subscription.current.tenant_id
  entra_app_client_id                   = data.azurerm_key_vault_secret.argocd_entra_app_client_id.value
  argocd_internal_url                   = local.argocd_internal_url
  kv_id                                 = data.azurerm_key_vault.cicd_kv.id
  aks_name                              = data.azurerm_kubernetes_cluster.aks.name
  aks_resource_group_name               = data.azurerm_kubernetes_cluster.aks.resource_group_name
  workload_identity_resource_group_name = data.azurerm_kubernetes_cluster.aks.resource_group_name
  location                              = var.location
  internal_dns_zone_name                = data.azurerm_private_dns_zone.internal.name
  internal_dns_zone_resource_group_name = data.azurerm_private_dns_zone.internal.resource_group_name
  ingress_load_balancer_ip              = var.ingress_load_balancer_ip
  dns_record_name_for_ingress           = local.argocd_dns_record_name

  enable_admin_login = true
  admin_password     = data.azurerm_key_vault_secret.argocd_admin_password.value

  tier = "dev"
  global_affinity_match_expressions = [
    {
      key      = "node_type"
      operator = "In"
      values   = ["user"]
    }
  ]

  entra_admin_group_object_ids = [data.azuread_group.adgroup_admin.object_id]

  tags = module.tag_config.tags

}

#---------------------------------------------------------------
# tools
#---------------------------------------------------------------

module "argocd_cert_mounter_workload_identity_init" {
  source = "./.terraform/modules/__v4__/kubernetes_workload_identity_init"

  workload_identity_name_prefix         = "argocd-cert-mounter"
  workload_identity_resource_group_name = data.azurerm_kubernetes_cluster.aks.resource_group_name
  workload_identity_location            = var.location
}

module "argocd_cert_mounter_workload_identity_configuration" {
  source = "./.terraform/modules/__v4__/kubernetes_workload_identity_configuration"

  workload_identity_name_prefix         = "argocd-cert-mounter"
  workload_identity_resource_group_name = data.azurerm_kubernetes_cluster.aks.resource_group_name
  aks_name                              = data.azurerm_kubernetes_cluster.aks.name
  aks_resource_group_name               = data.azurerm_kubernetes_cluster.aks.resource_group_name
  namespace                             = kubernetes_namespace.namespace_argocd.metadata[0].name

  key_vault_id                      = data.azurerm_key_vault.core_kv.id
  key_vault_certificate_permissions = ["Get"]
  key_vault_key_permissions         = ["Get"]
  key_vault_secret_permissions      = ["Get"]

  depends_on = [
    module.argocd_cert_mounter_workload_identity_init
  ]

}

module "argocd_cert_mounter_internal_domain_certificate" {
  source           = "./.terraform/modules/__v4__/cert_mounter"
  namespace        = "argocd"
  certificate_name = replace(local.argocd_internal_url, ".", "-")
  kv_name          = data.azurerm_key_vault.core_kv.name
  tenant_id        = data.azurerm_subscription.current.tenant_id

  workload_identity_service_account_name = module.argocd_cert_mounter_workload_identity_configuration.workload_identity_service_account_name
  workload_identity_client_id            = module.argocd_cert_mounter_workload_identity_configuration.workload_identity_client_id

  depends_on = [
    module.argocd,
    module.argocd_cert_mounter_workload_identity_configuration

  ]
}

resource "helm_release" "reloader_argocd" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = "v1.0.30"
  namespace  = kubernetes_namespace.namespace_argocd.metadata[0].name

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
}
