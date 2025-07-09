

#------------------------------------------------------------------------------
# Keycloak secrets
#------------------------------------------------------------------------------
resource "random_password" "keycloak_admin" {
  length  = 24
  special = true
}

resource "azurerm_key_vault_secret" "keycloak_admin_password" {
  name         = "keycloak-admin-password"
  value        = random_password.keycloak_admin.result
  key_vault_id = data.azurerm_key_vault.key_vault_core.id

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "keycloak_admin_username" {
  name         = "keycloak-admin-username"
  value        = "admin"
  key_vault_id = data.azurerm_key_vault.key_vault_core.id

  tags = module.tag_config.tags
}

resource "azurerm_key_vault_secret" "keycloak_url" {
  name         = "keycloak-url"
  value        = local.keycloak_ingress_hostname
  key_vault_id = data.azurerm_key_vault.key_vault_core.id

  tags = module.tag_config.tags
}

resource "kubernetes_secret" "keycloak_admin" {
  metadata {
    name      = "keycloak-admin-secret"
    namespace = kubernetes_namespace.keycloak.metadata[0].name
  }
  data = {
    "admin-password" = azurerm_key_vault_secret.keycloak_admin_password.value
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
    KC_HEALTH_ENABLED    = "true"
    KC_METRICS_ENABLED   = "true"
    KC_DB_URL_PROPERTIES = "sslmode=require"
  }
}

#TODO: Import admin realm to configure Keycloak with initial admin user and roles.
resource "kubernetes_config_map" "keycloak_realm_import" {
  metadata {
    name      = "keycloak-realm-import"
    namespace = local.keycloak_namespace
  }
  data = {
    "admin_realm.json" = templatefile("${path.module}/k8s/keycloak/admin_realm.json.tpl", {
      keycloak_admin_username = azurerm_key_vault_secret.keycloak_admin_username.value,
      keycloak_admin_password = azurerm_key_vault_secret.keycloak_admin_password.value
    })
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
      postgres_db_host            = module.keycloak_pgflex.fqdn
      postgres_db_port            = "5432"
      postgres_db_username        = module.keycloak_pgflex.administrator_login
      postgres_db_name            = local.keycloak_db_name
      keycloak_admin_username     = azurerm_key_vault_secret.keycloak_admin_username.value
      keycloak_ingress_hostname   = local.keycloak_ingress_hostname
      ingress_tls_secret_name     = replace(local.keycloak_ingress_hostname, ".", "-")
      keycloak_external_hostname  = local.keycloak_external_hostname
      replica_count_min           = var.keycloak_configuration.replica_count_min
      replica_count_max           = var.keycloak_configuration.replica_count_max
      realm_admin_import_filename = "admin_realm.json"
      force_deploy_version        = "v2"
    })
  ]
  depends_on = [
    kubernetes_secret.keycloak_admin,
    kubernetes_secret.keycloak_db,
    kubernetes_config_map.keycloak_config,
    kubernetes_namespace.keycloak,
  ]
}

#
# 🌐 DNS private - Records
#
resource "azurerm_private_dns_a_record" "keycloak" {
  name                = "keycloak.${var.location_short}"
  zone_name           = data.azurerm_private_dns_zone.internal.name
  resource_group_name = data.azurerm_private_dns_zone.internal.resource_group_name
  ttl                 = 3600
  records             = [local.aks_ingress_load_balancer_ip]

  tags = module.tag_config.tags
}
