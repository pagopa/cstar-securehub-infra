module "namespace_role_bindings" {
  source = "./.terraform/modules/__v4__/kubernetes_namespace_role_binding"

  name         = var.domain
  ad_group_ids = [for i in local.ad_group_rbac : i.object_id]
}

module "namespace_system_role_bindings" {
  source = "./.terraform/modules/__v4__/kubernetes_namespace_role_binding"

  name         = "${var.domain}-system"
  ad_group_ids = [for i in local.ad_group_rbac : i.object_id]
}

# Import needed because the module try to create existing namespace
import {
  id = "keycloak"
  to = module.namespace_keycloak_role_bindings.kubernetes_namespace.this
}

module "namespace_keycloak_role_bindings" {
  source = "./.terraform/modules/__v4__/kubernetes_namespace_role_binding"

  name         = "keycloak"
  ad_group_ids = [for i in local.ad_group_rbac : i.object_id]
}

resource "kubernetes_cluster_role_binding" "rbac_reader_global" {
  for_each = { for i in local.ad_group_rbac : i.object_id => i }

  metadata {
    name = "${each.value.display_name}.rbac-reader-global-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "rbac-reader"
  }

  subject {
    kind      = "Group"
    name      = each.value.object_id
    api_group = "rbac.authorization.k8s.io"
  }
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
