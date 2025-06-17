resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = "keycloak"
  }
}

resource "kubernetes_config_map" "keycloak-config" {
  metadata {
    name      = "keycloak-config"
    namespace = kubernetes_namespace.keycloak.metadata[0].name
  }

  data = {
    kc-db-schema = "public",
    kc-db-url-port = "5432",
    kc-db = "postgres"
  }
}
