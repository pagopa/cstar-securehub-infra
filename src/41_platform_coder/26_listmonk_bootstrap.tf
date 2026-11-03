data "azurerm_key_vault_secret" "listmonk_oidc_client_secret" {
  count = var.listmonk_sso.enabled ? 1 : 0

  name         = var.listmonk_sso.client_secret_name
  key_vault_id = data.azurerm_key_vault.key_vault_core.id
}

resource "random_password" "listmonk_admin" {
  length  = 32
  special = false
}

resource "azurerm_key_vault_secret" "listmonk_admin_password" {
  name         = "listmonk-admin-password"
  value        = random_password.listmonk_admin.result
  key_vault_id = data.azurerm_key_vault.key_vault_core.id
  content_type = "text/plain"

  tags = module.tag_config.tags
}

resource "kubernetes_secret" "listmonk_bootstrap" {
  metadata {
    name      = "listmonk-bootstrap"
    namespace = local.listmonk_namespace
  }

  data = {
    LISTMONK_ADMIN_USER     = "admin"
    LISTMONK_ADMIN_PASSWORD = azurerm_key_vault_secret.listmonk_admin_password.value
    LISTMONK_OIDC_CONFIG = jsonencode({
      enabled              = var.listmonk_sso.enabled
      provider_url         = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/v2.0"
      provider_name        = "Microsoft Entra ID"
      client_id            = var.listmonk_sso.client_id
      client_secret        = var.listmonk_sso.enabled ? data.azurerm_key_vault_secret.listmonk_oidc_client_secret[0].value : ""
      auto_create_users    = var.listmonk_sso.auto_create_users
      default_user_role_id = var.listmonk_sso.default_user_role_id
      default_list_role_id = null
    })
  }
}

resource "kubernetes_config_map" "listmonk_bootstrap" {
  metadata {
    name      = "listmonk-bootstrap"
    namespace = local.listmonk_namespace
  }

  data = {
    "settings.sql" = file("${path.module}/k8s/listmonk/settings.sql")
  }
}

locals {
  listmonk_bootstrap_checksum = nonsensitive(sha256(jsonencode({
    image          = "${var.listmonk_configuration.image_repository}:${var.listmonk_configuration.image_tag}"
    settings       = kubernetes_config_map.listmonk_bootstrap.data
    bootstrap      = kubernetes_secret.listmonk_bootstrap.data
    database       = kubernetes_secret.listmonk_db.data
    host           = module.keycloak_pgflex.fqdn
    ssl_mode       = var.listmonk_configuration.postgres_ssl_mode
    root_url       = "https://${local.listmonk_ingress_hostname}"
    postgres_image = var.listmonk_configuration.bootstrap_postgres_image
  })))
}

# Listmonk loads OIDC settings from its database, overriding file/env settings.
resource "kubernetes_job_v1" "listmonk_bootstrap" {
  metadata {
    name      = "listmonk-bootstrap-${substr(local.listmonk_bootstrap_checksum, 0, 12)}"
    namespace = local.listmonk_namespace
  }

  spec {
    backoff_limit           = 1
    active_deadline_seconds = 600

    template {
      metadata {
        labels = {
          app = "listmonk-bootstrap"
        }
      }

      spec {
        restart_policy                  = "Never"
        automount_service_account_token = false

        node_selector = {
          domain = "keycloak"
        }

        toleration {
          key      = "keycloakOnly"
          operator = "Equal"
          value    = "true"
          effect   = "NoSchedule"
        }

        security_context {
          run_as_non_root = true
          run_as_user     = 65534
          run_as_group    = 65534
          fs_group        = 65534
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        init_container {
          name    = "install"
          image   = "${var.listmonk_configuration.image_repository}:${var.listmonk_configuration.image_tag}"
          command = ["sh", "-ec", "./listmonk --config='' --install --idempotent --yes && ./listmonk --config='' --upgrade --yes"]

          dynamic "env" {
            for_each = {
              LISTMONK_db__host     = module.keycloak_pgflex.fqdn
              LISTMONK_db__port     = "5432"
              LISTMONK_db__database = azurerm_postgresql_flexible_server_database.listmonk_db.name
              LISTMONK_db__ssl_mode = var.listmonk_configuration.postgres_ssl_mode
            }
            content {
              name  = env.key
              value = env.value
            }
          }

          dynamic "env" {
            for_each = {
              LISTMONK_db__user     = "db_user"
              LISTMONK_db__password = "db_password"
            }
            content {
              name = env.key
              value_from {
                secret_key_ref {
                  name = kubernetes_secret.listmonk_db.metadata[0].name
                  key  = env.value
                }
              }
            }
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.listmonk_bootstrap.metadata[0].name
            }
          }

          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem  = true
            capabilities {
              drop = ["ALL"]
            }
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }
        }

        container {
          name    = "settings"
          image   = var.listmonk_configuration.bootstrap_postgres_image
          command = ["psql", "-X", "--set=ON_ERROR_STOP=1", "--file=/bootstrap/settings.sql"]

          dynamic "env" {
            for_each = {
              PGHOST            = module.keycloak_pgflex.fqdn
              PGPORT            = "5432"
              PGDATABASE        = azurerm_postgresql_flexible_server_database.listmonk_db.name
              PGSSLMODE         = var.listmonk_configuration.postgres_ssl_mode
              LISTMONK_ROOT_URL = "https://${local.listmonk_ingress_hostname}"
            }
            content {
              name  = env.key
              value = env.value
            }
          }

          dynamic "env" {
            for_each = {
              PGUSER     = "db_user"
              PGPASSWORD = "db_password"
            }
            content {
              name = env.key
              value_from {
                secret_key_ref {
                  name = kubernetes_secret.listmonk_db.metadata[0].name
                  key  = env.value
                }
              }
            }
          }

          env {
            name = "LISTMONK_OIDC_CONFIG"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.listmonk_bootstrap.metadata[0].name
                key  = "LISTMONK_OIDC_CONFIG"
              }
            }
          }

          volume_mount {
            name       = "bootstrap"
            mount_path = "/bootstrap"
            read_only  = true
          }

          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem  = true
            capabilities {
              drop = ["ALL"]
            }
          }
        }

        volume {
          name = "tmp"
          empty_dir {}
        }

        volume {
          name = "bootstrap"
          config_map {
            name = kubernetes_config_map.listmonk_bootstrap.metadata[0].name
          }
        }
      }
    }
  }

  wait_for_completion = true

  timeouts {
    create = "12m"
    update = "12m"
  }

  depends_on = [
    postgresql_grant.listmonk_database,
    postgresql_grant.listmonk_schema,
    postgresql_extension.listmonk_pgcrypto
  ]
}
