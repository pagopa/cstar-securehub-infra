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
