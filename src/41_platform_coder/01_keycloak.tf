resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = "keycloak"
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

resource "kubernetes_secret" "credentials_postgress_admin" {
  metadata {
    name      = "keycloak-admin-secret"
    namespace = kubernetes_namespace.keycloak.metadata[0].name
  }

  data = {
    "admin-username" = data.azurerm_key_vault_secret.postgres_admin_username.value
    "admin-password" = data.azurerm_key_vault_secret.postgres_admin_password.value
  }

  type = "Opaque"
}
# nuova risorsa kubernetes secret per utilizzare secret
# hostname definito in configMap
