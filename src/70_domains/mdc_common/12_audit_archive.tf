### 🗄️ Compliance / Audit — archiviazione a lungo termine su Blob Storage
#
# Requisito: conservare i log applicativi principali (AppTraces, AppExceptions,
# AppRequests, AppDependencies) per 180 gg a fini di Audit, leggendoli
# raramente (solo ispezioni/controlli legali) e spendendo il meno possibile.
#
# Strategia (massimo risparmio):
#   1) Storage Account creato tramite il modulo standard IDH/storage_account
#      (tier "basic_audit"): gestisce in automatico private endpoint, accesso
#      pubblico disabilitato, threat protection e niente soft-delete/versioning
#      (dati di audit immutabili). Stesso pattern usato da idpay_common.
#   2) Log Analytics Data Export Rule: devia in CONTINUO le sole tabelle scelte
#      dal workspace verso lo storage (nessun costo di Archive su Log Analytics).
#   3) Lifecycle Management Policy: sposta subito i blob su tier Cool (tariffa
#      ridotta per dati letti di rado) e li elimina superata la finestra di
#      compliance, così non si accumulano costi.
#
# Parametrizzazione: in prod l'export è attivo (180 gg); in dev/uat è
# disattivabile (var.audit_export_enabled = false) per non spendere nulla.

module "audit_storage" {
  count  = var.audit_export_enabled ? 1 : 0
  source = "./.terraform/modules/__v4__/IDH/storage_account"

  # General
  product_name        = var.prefix
  env                 = var.env
  location            = var.location
  resource_group_name = local.monitor_rg
  tags                = module.tag_config.tags

  #
  idh_resource_tier = var.audit_storage_account_tier

  # Storage Account Settings
  name             = local.audit_storage_account_name
  domain           = var.domain
  replication_type = var.audit_storage_account_replication_type

  # Network — private endpoint per i blob nella subnet dedicata agli storage.
  private_dns_zone_blob_ids  = [data.azurerm_private_dns_zone.blob_storage.id]
  private_endpoint_subnet_id = module.storage_snet.subnet_id
}

# 🔁 Esportazione automatica delle tabelle di tracing verso il blob storage.
resource "azurerm_log_analytics_data_export_rule" "audit" {
  count = var.audit_export_enabled ? 1 : 0

  name                    = local.audit_export_rule_name
  resource_group_name     = local.monitor_rg
  workspace_resource_id   = azurerm_log_analytics_workspace.log_analytics_workspace.id
  destination_resource_id = module.audit_storage[0].id
  table_names             = local.app_insights_long_term_tables
  enabled                 = true
}

# ⏳ Ciclo di vita: cancellazione oltre la compliance window.
resource "azurerm_storage_management_policy" "audit" {
  count = var.audit_export_enabled ? 1 : 0

  storage_account_id = module.audit_storage[0].id

  rule {
    name    = "audit-lifecycle"
    enabled = true

    filters {
      # I blob creati dal Data Export sono block blob nei container "am-<table>".
      blob_types = ["blockBlob"]
    }

    actions {
      base_blob {
        # Cancellazione definitiva una volta superati i giorni di retention.
        delete_after_days_since_creation_greater_than = var.audit_logs_retention_days
      }
    }
  }
}
