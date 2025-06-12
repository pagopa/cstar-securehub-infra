resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = "idpay"
  }
}

resource "kubernetes_manifest" "keycloak_service" {
  manifest = yamldecode(file("${path.module}/keycloak_service.yaml"))
}


resource "kubernetes_manifest" "keycloak_deployment" {
  manifest = yamldecode(file("${path.module}/keycloak_deployment.yaml"))
}

resource "kubernetes_manifest" "keycloak_ingress" {
  manifest = yamldecode(file("${path.module}/keycloak_ingress.yaml"))
}
