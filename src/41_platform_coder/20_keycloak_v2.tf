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
  key_vault_id = data.azurerm_key_vault.key_vault_core.id
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
    "db-password" = azurerm_key_vault_secret.keycloak_db_admin_password.value
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
    KC_DB_URL_PROPERTIES = "sslmode=require"
  }
}

resource "helm_release" "keycloak" {
  name       = "keycloak"
  namespace  = kubernetes_namespace.keycloak.metadata[0].name
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "keycloak"
  version    = "24.7.4"

  values = [
    templatefile("${path.module}/k8s/keycloak/values.yaml.tpl", {
      postgres_db_host         = module.keycloak_pgflex.fqdn
      postgres_db_port         = "5432"
      postgres_db_username     = module.keycloak_pgflex.administrator_login
      postgres_db_name         = local.keycloak_db_name
      keycloak_ingress_hostname = local.keycloak_ingress_hostname
      ingress_tls_secret_name  = replace(local.keycloak_ingress_hostname, ".", "-")
      replica_count_min        = var.keycloak_configuration.replica_count_min
      replica_count_max        = var.keycloak_configuration.replica_count_max
    })
  ]
  depends_on = [
    kubernetes_secret.keycloak_admin,
    kubernetes_secret.keycloak_db,
    kubernetes_config_map.keycloak_config,
    kubernetes_namespace.keycloak
  ]
}
