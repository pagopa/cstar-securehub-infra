resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.domain
  }
}

resource "kubernetes_namespace" "system_domain_namespace" {
  metadata {
    name = "${var.domain}-system"
  }
}

module "namespace_role_bindings" {
  source = "./.terraform/modules/__v4__/kubernetes_namespace_role_binding"

  name                  = var.domain
  ad_group_ids          = [data.azuread_group.adgroup_idpay_admin.object_id]
  rbac_reader_name_role = "rbac-reader"
}

module "namespace_system_role_bindings" {
  source = "./.terraform/modules/__v4__/kubernetes_namespace_role_binding"

  name                  = "${var.domain}-system"
  ad_group_ids          = [data.azuread_group.adgroup_idpay_admin.object_id]
  rbac_reader_name_role = "rbac-reader"
}

module "workload_identity_v2" {
  source = "./.terraform/modules/__v4__/kubernetes_workload_identity_init"

  workload_identity_name_prefix         = "${var.domain}-${var.location_short}"
  workload_identity_resource_group_name = data.azurerm_kubernetes_cluster.aks.resource_group_name
  workload_identity_location            = var.location
}


module "workload_identity_configuration_v2" {
  source = "./.terraform/modules/__v4__/kubernetes_workload_identity_configuration"

  workload_identity_name_prefix         = "${var.domain}-${var.location_short}"
  workload_identity_resource_group_name = data.azurerm_kubernetes_cluster.aks.resource_group_name
  aks_name                              = data.azurerm_kubernetes_cluster.aks.name
  aks_resource_group_name               = data.azurerm_kubernetes_cluster.aks.resource_group_name
  namespace                             = var.domain

  key_vault_id                      = data.azurerm_key_vault.domain_kv.id
  key_vault_certificate_permissions = ["Get"]
  key_vault_key_permissions         = ["Get", "Decrypt", "Encrypt"]
  key_vault_secret_permissions      = ["Get"]

  depends_on = [
    module.workload_identity_v2,
  ]
}
