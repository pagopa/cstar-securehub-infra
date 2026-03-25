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
