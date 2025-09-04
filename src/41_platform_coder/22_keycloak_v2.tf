locals {
  theme_dir   = "${path.module}/k8s/keycloak/themes/pagopa/login"
  files       = fileset(local.theme_dir, "**")
  binary_exts = [".png", ".jpg", ".jpeg", ".ico", ".woff", ".woff2"]

  flattened_key = { for f in local.files : f => replace(f, "/", "__") }

  text_files = {
    for f in local.files :
    local.flattened_key[f] => file("${local.theme_dir}/${f}")
    if !endswith(f, "/") && !contains(local.binary_exts, lower(substr(f, length(f) - 4, 5)))
  }

  binary_files = {
    for f in local.files :
    local.flattened_key[f] => filebase64("${local.theme_dir}/${f}")
    if !endswith(f, "/") && contains(local.binary_exts, lower(substr(f, length(f) - 4, 5)))
  }

  # Fixed volume mount
  fixed_volume_mounts = [
    {
      name      = "realm-import"
      mountPath = "/opt/bitnami/keycloak/data/import"
      readOnly  = true
    }
  ]

  # Create a volume mount for each file in configmap with subPath
  theme_volume_mounts = [
    for f in local.files : {
      name      = "pagopa-theme"
      mountPath = "/opt/bitnami/keycloak/themes/pagopa/login/${f}"
      subPath   = local.flattened_key[f]
      readOnly  = true
    }
    if !endswith(f, "/")
  ]

  # Merge volume mount
  keycloak_extra_volume_mounts = concat(local.fixed_volume_mounts, local.theme_volume_mounts)

}

#------------------------------------------------------------------------------
# Keycloak secrets
#------------------------------------------------------------------------------
resource "random_password" "keycloak_admin" {
  length  = 24
  special = true
}

# resource "random_password" "terraform_client_secret" {
#   length  = 24
#   special = true
# }

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

# resource "azurerm_key_vault_secret" "terraform_client_secret_for_keycloak" {
#   name         = "terraform-client-secret-for-keycloak"
#   value        = random_password.terraform_client_secret.result
#   key_vault_id = data.azurerm_key_vault.key_vault_core.id
# }

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

resource "kubernetes_config_map" "keycloak_pagopa_theme" {
  metadata {
    name      = "keycloak-pagopa-theme"
    namespace = local.keycloak_namespace
  }

  data        = local.text_files
  binary_data = local.binary_files
}

resource "helm_release" "keycloak" {
  name       = "keycloak"
  namespace  = kubernetes_namespace.keycloak.metadata[0].name
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "keycloak"
  version    = "24.7.4"

  values = [
    templatefile("${path.module}/k8s/keycloak/values.yaml.tpl", {
      postgres_db_host                                = module.keycloak_pgflex.fqdn
      postgres_db_port                                = "5432"
      postgres_db_username                            = module.keycloak_pgflex.administrator_login
      postgres_db_name                                = local.keycloak_db_name
      keycloak_admin_username                         = azurerm_key_vault_secret.keycloak_admin_username.value
      keycloak_ingress_hostname                       = local.keycloak_ingress_hostname
      ingress_tls_secret_name                         = replace(local.keycloak_ingress_hostname, ".", "-")
      keycloak_external_hostname                      = local.keycloak_external_hostname
      replica_count_min                               = var.keycloak_configuration.replica_count_min
      replica_count_max                               = var.keycloak_configuration.replica_count_max
      force_deploy_version                            = "v2"
      keycloak_extra_volume_mounts                    = yamlencode(local.keycloak_extra_volume_mounts)
      keycloak_http_client_connection_ttl_millis      = var.keycloak_configuration.http_client_connection_ttl_millis
      keycloak_http_client_connection_max_idle_millis = var.keycloak_configuration.http_client_connection_max_idle_time_millis
    })
  ]
  depends_on = [
    kubernetes_secret.keycloak_admin,
    kubernetes_secret.keycloak_db,
    kubernetes_config_map.keycloak_config,
    kubernetes_namespace.keycloak
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
