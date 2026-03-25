resource "kubernetes_role_binding" "ad_group_binding" {
  metadata {
    name      = "ad-group-edit-binding"
    namespace = "mdc"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }

  subject {
    kind      = "Group"
    name      = "5a9f7e7d-472b-4a2a-adb9-f9af41c93faf" # AD
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_role_binding" "ad_group_idpay_binding" {
  metadata {
    name      = "ad-group-idpay-edit-binding"
    namespace = "idpay"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }

  subject {
    kind      = "Group"
    name      = "3715c6e7-28e1-4e9d-bbf1-67976dd0b6d9" # AD
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role" "ad_group_cluster_role_binding_reader" {
  metadata {
    name = "ad-group-cluster-role"
  }

  rule {
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["rolebindings", "roles"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "ad_group_idpay_binding_v2" {
  metadata {
    name      = "ad-group-idpay-view-binding"
    namespace = "idpay"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.ad_group_cluster_role_binding_reader.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "3715c6e7-28e1-4e9d-bbf1-67976dd0b6d9" # AD
    api_group = "rbac.authorization.k8s.io"
  }
}
