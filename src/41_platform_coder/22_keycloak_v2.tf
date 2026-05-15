locals {
  themes_dir     = "${path.module}/k8s/keycloak/themes"
  files          = fileset(local.themes_dir, "**")
  binary_exts    = [".png", ".jpg", ".jpeg", ".ico", ".woff", ".woff2"]
  provider_dir   = "${path.module}/k8s/keycloak/providers"
  provider_files = fileset(local.provider_dir, "*.jar")

  flattened_key = { for f in local.files : f => replace(f, "/", "__") }

  text_files = {
    for f in local.files :
    local.flattened_key[f] => file("${local.themes_dir}/${f}")
    if !endswith(f, "/") && !contains(local.binary_exts, lower(substr(f, length(f) - 4, 5)))
  }

  binary_files = {
    for f in local.files :
    local.flattened_key[f] => filebase64("${local.themes_dir}/${f}")
    if !endswith(f, "/") && contains(local.binary_exts, lower(substr(f, length(f) - 4, 5)))
  }

  # Fixed volume mount
  fixed_volume_mounts = [
    {
      name      = "agent"
      mountPath = "/opt/bitnami/keycloak/agent"
    }
  ]

  # Create a volume mount for each file in configmap with subPath
  theme_volume_mounts = [
    for f in local.files : {
      name      = "pagopa-theme"
      mountPath = "/opt/bitnami/keycloak/themes/${f}"
      subPath   = local.flattened_key[f]
      readOnly  = true
    }
    if !endswith(f, "/")
  ]

  provider_volume_mounts = [
    for f in local.provider_files : {
      name      = "keycloak-providers"
      mountPath = "/opt/bitnami/keycloak/providers/${f}"
      subPath   = f
      readOnly  = true
    }
  ]

  # Merge volume mount
  keycloak_extra_volume_mounts = concat(local.fixed_volume_mounts, local.theme_volume_mounts, local.provider_volume_mounts)

  keycloak_provider_cm_name = "keycloak-providers"

  # Volume for providers
  provider_volume = {
    name = "keycloak-providers"
    configMap = {
      name = kubernetes_config_map.keycloak_providers.metadata[0].name
    }
  }

}

#------------------------------------------------------------------------------
# Keycloak secrets
#------------------------------------------------------------------------------
resource "random_password" "keycloak_admin" {
  length  = 24
  special = true
}

resource "random_password" "terraform_client_secret" {
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

resource "azurerm_key_vault_secret" "terraform_client_secret_for_keycloak" {
  name         = "terraform-client-secret-for-keycloak"
  value        = random_password.terraform_client_secret.result
  key_vault_id = data.azurerm_key_vault.key_vault_core.id

  tags = module.tag_config.tags

  depends_on = [random_password.terraform_client_secret]
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

resource "kubernetes_config_map" "keycloak-terraform-client-config" {
  metadata {
    name      = "keycloak-terraform-client-config"
    namespace = local.keycloak_namespace
  }
  data = merge({
    "terraform_client.json" = templatefile("${path.module}/k8s/keycloak/terraform_client.json.tpl", {
      keycloak_terraform_client_secret = azurerm_key_vault_secret.terraform_client_secret_for_keycloak.value
    })
    }, var.it_wallet_oid4vp_provider.enabled ? {
    "user_it_wallet_oid4vp_provider.json" = templatefile("${path.module}/k8s/keycloak/user_it_wallet_oid4vp_provider.json.tpl", {
      alias                            = var.it_wallet_oid4vp_provider.alias
      display_name                     = var.it_wallet_oid4vp_provider.display_name
      realm_name                       = var.it_wallet_oid4vp_provider.realm_name
      credential_format                = var.it_wallet_oid4vp_provider.credential_format
      credential_type                  = var.it_wallet_oid4vp_provider.credential_type
      first_name_claim                 = var.it_wallet_oid4vp_provider.first_name_claim
      last_name_claim                  = var.it_wallet_oid4vp_provider.last_name_claim
      date_of_birth_claim              = var.it_wallet_oid4vp_provider.date_of_birth_claim
      username_claim                   = var.it_wallet_oid4vp_provider.username_claim
      fiscal_number_claim              = var.it_wallet_oid4vp_provider.fiscal_number_claim
      user_mapping_claim               = var.it_wallet_oid4vp_provider.user_mapping_claim
      user_mapping_claim_mdoc          = var.it_wallet_oid4vp_provider.user_mapping_claim_mdoc
      same_device_enabled              = tostring(var.it_wallet_oid4vp_provider.same_device_enabled)
      cross_device_enabled             = tostring(var.it_wallet_oid4vp_provider.cross_device_enabled)
      wallet_scheme                    = var.it_wallet_oid4vp_provider.wallet_scheme
      response_mode                    = var.it_wallet_oid4vp_provider.response_mode
      client_id_scheme                 = var.it_wallet_oid4vp_provider.client_id_scheme
      enforce_haip                     = tostring(var.it_wallet_oid4vp_provider.enforce_haip)
      credential_set_mode              = var.it_wallet_oid4vp_provider.credential_set_mode
      credential_set_purpose_json      = jsonencode(var.it_wallet_oid4vp_provider.credential_set_purpose)
      dcql_query_json                  = jsonencode(var.it_wallet_oid4vp_provider.dcql_query)
      verifier_info_json               = jsonencode(var.it_wallet_oid4vp_provider.verifier_info)
      x509_certificate_pem_json        = "" //todo jsonencode(try(data.azurerm_key_vault_secret.it_wallet_x509_certificate_pem[0].value, ""))
      trust_list_url_json              = jsonencode(var.it_wallet_oid4vp_provider.trust_list_url)
      trust_list_lote_type_json        = jsonencode(var.it_wallet_oid4vp_provider.trust_list_lote_type)
      trusted_authorities_mode         = var.it_wallet_oid4vp_provider.trusted_authorities_mode
      trust_list_signing_cert_pem_json = "" //todo jsonencode(try(data.azurerm_key_vault_secret.it_wallet_trust_list_signing_cert_pem[0].value, ""))
      allowed_issuers                  = var.it_wallet_oid4vp_provider.allowed_issuers
      client_metadata_json             = jsonencode(var.it_wallet_oid4vp_provider.client_metadata)
    })
  } : {})

  depends_on = [azurerm_key_vault_secret.terraform_client_secret_for_keycloak]
}

resource "kubernetes_config_map" "keycloak_pagopa_theme" {
  metadata {
    name      = "keycloak-pagopa-theme"
    namespace = local.keycloak_namespace
  }

  data        = local.text_files
  binary_data = local.binary_files
}

resource "kubernetes_config_map" "keycloak_providers" {
  metadata {
    name      = local.keycloak_provider_cm_name
    namespace = local.keycloak_namespace
  }

  binary_data = {
    for f in local.provider_files : f => filebase64("${local.provider_dir}/${f}")
  }
}

resource "helm_release" "keycloak" {
  name      = "keycloak"
  namespace = kubernetes_namespace.keycloak.metadata[0].name
  #https://github.com/bitnami/charts/tree/main/bitnami/keycloak
  repository = "oci://registry-1.docker.io/bitnamicharts"
  #https://artifacthub.io/packages/helm/bitnami/keycloak/
  #https://gallery.ecr.aws/bitnami/keycloak
  chart   = "keycloak"
  version = var.keycloak_configuration.chart_version

  values = [
    templatefile("${path.module}/k8s/keycloak/values.yaml.tpl", {
      image_registry                                  = var.keycloak_configuration.image_registry
      image_repository                                = var.keycloak_configuration.image_repository
      image_tag                                       = var.keycloak_configuration.image_tag
      image_registry_config_cli                       = var.keycloak_configuration.image_registry_config_cli
      image_repository_config_cli                     = var.keycloak_configuration.image_repository_config_cli
      image_tag_config_cli                            = var.keycloak_configuration.image_tag_config_cli
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
      cpu_request                                     = var.keycloak_configuration.cpu_request
      cpu_limit                                       = var.keycloak_configuration.cpu_limit
      memory_request                                  = var.keycloak_configuration.memory_request
      memory_limit                                    = var.keycloak_configuration.memory_limit
      force_deploy_version                            = "v2"
      keycloak_extra_volume_mounts                    = yamlencode(local.keycloak_extra_volume_mounts)
      keycloak_http_client_connection_ttl_millis      = var.keycloak_configuration.http_client_connection_ttl_millis
      keycloak_http_client_connection_max_idle_millis = var.keycloak_configuration.http_client_connection_max_idle_time_millis
      appinsights_connection_string                   = data.azurerm_application_insights.app_insights_core.connection_string
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
