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

locals {
  listmonk_helm_values = templatefile("${path.module}/k8s/listmonk/values.yaml.tpl", {
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
    bootstrap_postgres_image  = var.listmonk_configuration.bootstrap_postgres_image
  })
}

resource "azurerm_private_dns_a_record" "listmonk" {
  name                = "listmonk.${var.location_short}"
  zone_name           = data.azurerm_private_dns_zone.internal.name
  resource_group_name = data.azurerm_private_dns_zone.internal.resource_group_name
  ttl                 = 3600
  records             = [local.aks_ingress_load_balancer_ip]

  tags = module.tag_config.tags
}
