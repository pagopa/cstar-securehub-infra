resource "azurerm_key_vault_secret" "listmonk_url" {
  name         = "listmonk-url"
  value        = local.listmonk_ingress_hostname
  key_vault_id = data.azurerm_key_vault.key_vault_core.id

  tags = module.tag_config.tags
}

resource "kubernetes_secret" "listmonk_db" {
  metadata {
    name      = "listmonk-db-secret"
    namespace = local.listmonk_namespace
  }

  data = {
    db_password = azurerm_key_vault_secret.listmonk_db_password.value
    db_user     = postgresql_role.listmonk.name
  }
}

resource "helm_release" "listmonk" {
  name       = "listmonk"
  repository = "https://repo.helmforge.dev"
  chart      = "listmonk"
  version    = var.listmonk_configuration.chart_version
  namespace  = local.listmonk_namespace

  postrender {
    binary_path = "/bin/bash"
    args        = ["${path.module}/k8s/listmonk/post-render.sh"]
  }

  values = [
    templatefile("${path.module}/k8s/listmonk/values.yaml.tpl", {
      image_repository          = var.listmonk_configuration.image_repository
      image_tag                 = var.listmonk_configuration.image_tag
      replica_count             = var.listmonk_configuration.replica_count
      listmonk_ingress_hostname = local.listmonk_ingress_hostname
      ingress_tls_secret_name   = replace(local.listmonk_ingress_hostname, ".", "-")
      postgres_db_name          = azurerm_postgresql_flexible_server_database.listmonk_db.name
      postgres_db_host          = module.keycloak_pgflex.fqdn
      postgres_db_port          = 5432
      postgres_db_username      = postgresql_role.listmonk.name
      postgres_ssl_mode         = var.listmonk_configuration.postgres_ssl_mode
      bootstrap_checksum        = local.listmonk_bootstrap_checksum
      bootstrap_postgres_image  = var.listmonk_configuration.bootstrap_postgres_image
    })
  ]

  depends_on = [
    kubernetes_job_v1.listmonk_bootstrap,
    module.listmonk_cert_mounter,
    azurerm_private_dns_a_record.listmonk
  ]
}

resource "azurerm_private_dns_a_record" "listmonk" {
  name                = "listmonk.${var.location_short}"
  zone_name           = data.azurerm_private_dns_zone.internal.name
  resource_group_name = data.azurerm_private_dns_zone.internal.resource_group_name
  ttl                 = 3600
  records             = [local.aks_ingress_load_balancer_ip]

  tags = module.tag_config.tags
}
