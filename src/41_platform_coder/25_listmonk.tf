data "kubernetes_namespace" "idpay" {
  metadata {
    name = "idpay"
  }
}

resource "azurerm_key_vault_secret" "listmonk_url" {
  name         = "listmonk-url"
  value        = local.listmonk_ingress_hostname
  key_vault_id = data.azurerm_key_vault.key_vault_core.id

  tags = module.tag_config.tags
}

resource "azurerm_postgresql_flexible_server_database" "listmonk_db" {
  name      = local.listmonk_db_name
  server_id = module.keycloak_pgflex.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "kubernetes_secret" "listmonk_db" {
  metadata {
    name      = "listmonk-db-secret"
    namespace = data.kubernetes_namespace.idpay.metadata[0].name #local.listmonk_namespace
  }

  data = {
    "db_password" = azurerm_key_vault_secret.keycloak_db_admin_password.value
    "db_user"     = module.keycloak_pgflex.administrator_login
  }
}

resource "helm_release" "listmonk" {
  name       = "listmonk"
  repository = "https://th0th.github.io/helm-charts"
  chart      = "listmonk"
  version    = var.listmonk_configuration.chart_version
  namespace  = data.kubernetes_namespace.idpay.metadata[0].name #local.listmonk_namespace

  values = [
    templatefile("${path.module}/k8s/listmonk/values.yaml.tpl", {
      image_repository          = var.listmonk_configuration.image_repository
      image_tag                 = var.listmonk_configuration.image_tag
      replica_count             = var.listmonk_configuration.replica_count
      listmonk_ingress_hostname = local.listmonk_ingress_hostname
      ingress_tls_secret_name   = replace(local.listmonk_ingress_hostname, ".", "-")
      postgres_db_name          = local.listmonk_db_name
      postgres_db_host          = module.keycloak_pgflex.fqdn
      postgres_db_port          = 5432
      postgres_ssl_mode         = var.listmonk_configuration.postgres_ssl_mode
    })
  ]

  depends_on = [
    azurerm_postgresql_flexible_server_database.listmonk_db,
    kubernetes_secret.listmonk_db,
    data.kubernetes_namespace.idpay #local.listmonk_namespace
  ]
}

# resource "azurerm_private_dns_a_record" "listmonk" {
#   name                = "listmonk.${var.location_short}"
#   zone_name           = data.azurerm_private_dns_zone.internal.name
#   resource_group_name = data.azurerm_private_dns_zone.internal.resource_group_name
#   ttl                 = 3600
#   records             = [local.aks_ingress_load_balancer_ip]
#
#   tags = module.tag_config.tags
# }
