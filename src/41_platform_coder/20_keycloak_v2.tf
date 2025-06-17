resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = "keycloak"
  }
}

