resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = "keycloak"
  }
}

#------------------------------------------------------------------------------
# Keycloak secrets
#------------------------------------------------------------------------------
resource "random_password" "keycloak_admin" {
  length  = 24
  special = true
}

resource "azurerm_key_vault_secret" "keycloak_admin" {
  name         = "keycloak-admin-password"
  value        = random_password.keycloak_admin.result
  key_vault_id = data.azurerm_key_vault.key_vault_domain.id
}

resource "kubernetes_secret" "keycloak_admin" {
  metadata {
    name      = "keycloak-admin-secret"
    namespace = kubernetes_namespace.keycloak.metadata[0].name
  }
  data = {
    "admin-password" = azurerm_key_vault_secret.keycloak_admin.value
  }
}

resource "kubernetes_secret" "keycloak_db" {
  metadata {
    name      = "keycloak-db-secret"
    namespace = kubernetes_namespace.keycloak.metadata[0].name
  }
  data = {
    "password" = azurerm_key_vault_secret.keycloak_db_admin_password.value
  }
}

#------------------------------------------------------------------------------
# Kubernetes
#------------------------------------------------------------------------------
resource "kubernetes_config_map" "keycloak_config" {
  metadata {
    name      = "keycloak-config"
    namespace = kubernetes_namespace.keycloak.metadata[0].name
  }
  data = {
    KC_HEALTH_ENABLED  = "true"
    KC_METRICS_ENABLED = "true"
  }
}

resource "helm_release" "keycloak" {
  name       = "keycloak"
  namespace  = kubernetes_namespace.keycloak.metadata[0].name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "keycloak"
  version    = "24.7.4" 

  values = [
    templatefile("${path.module}/values.yaml.tmpl", {
      replica_count   = 1
      env             = var.env
      tls_secret_name = var.tls_secret_name
    })
  ]
  depends_on = [
    kubernetes_secret.keycloak_admin,
    kubernetes_secret.keycloak_db,
    kubernetes_config_map.keycloak_config,
    kubernetes_namespace.keycloak
  ]
}
