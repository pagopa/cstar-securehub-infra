### 🗄️ Compliance / Audit — archiviazione a lungo termine su Blob Storage
#
# Requisito: conservare i log applicativi principali (AppTraces, AppExceptions,
# AppRequests, AppDependencies) per 180 gg a fini di Audit, leggendoli
# raramente (solo ispezioni/controlli legali) e spendendo il meno possibile.
#
# Strategia (massimo risparmio):
#   1) Log Analytics Data Export Rule: devia in CONTINUO le sole tabelle scelte
#      dal workspace verso uno Storage Account dedicato (nessun costo di
#      interactive/Archive retention su Log Analytics oltre i 90 gg gratuiti).
#   2) Storage Account con access_tier = "Cool": tariffa di storage ridotta,
#      pensata per dati letti di rado ma comunque immediatamente disponibili.
#   3) Lifecycle Management Policy: cancella automaticamente i blob una volta
#      superata la finestra di compliance, così non si accumulano costi.
#
# Parametrizzazione: in prod l'export è attivo (180 gg); in dev/uat è
# disattivabile (var.audit_export_enabled = false) per non spendere nulla.

resource "azurerm_storage_account" "audit" {
  count = var.audit_export_enabled ? 1 : 0

  name                = local.audit_storage_account_name
  resource_group_name = local.monitor_rg
  location            = var.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = var.audit_storage_account_replication_type
  access_tier              = "Cool" # 🧊 tariffa storage economica per dati letti di rado

  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  # 🔒 Accesso solo da rete privata: il firewall nega tutto il traffico pubblico,
  # tranne i servizi trusted di Azure (necessari al Log Analytics Data Export per
  # scrivere i blob). La lettura per Audit avviene tramite il private endpoint.
  public_network_access_enabled = true
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices", "Logging", "Metrics"]
  }

  # Niente versioning/soft-delete: dati immutabili append-only dell'export, il
  # ciclo di vita è gestito dalla policy sotto. Riduce ulteriormente i costi.
  blob_properties {
    last_access_time_enabled = false
  }

  tags = module.tag_config.tags
}

# 🔌 Private endpoint per i blob, nella subnet dedicata agli storage privati.
resource "azurerm_private_endpoint" "audit_blob" {
  count = var.audit_export_enabled ? 1 : 0

  name                = "${local.audit_storage_account_name}-blob-prv-endpoint"
  location            = var.location
  resource_group_name = local.monitor_rg
  subnet_id           = module.storage_snet.subnet_id

  private_service_connection {
    name                           = "${local.audit_storage_account_name}-blob-prv-conn"
    private_connection_resource_id = azurerm_storage_account.audit[0].id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.blob_storage.id]
  }

  tags = module.tag_config.tags
}

# 🔁 Esportazione automatica delle tabelle di tracing verso il blob storage.
resource "azurerm_log_analytics_data_export_rule" "audit" {
  count = var.audit_export_enabled ? 1 : 0

  name                    = "${local.project}-audit-export"
  resource_group_name     = local.monitor_rg
  workspace_resource_id   = azurerm_log_analytics_workspace.log_analytics_workspace.id
  destination_resource_id = azurerm_storage_account.audit[0].id
  table_names             = local.app_insights_long_term_tables
  enabled                 = true
}

# ⏳ Ciclo di vita: elimina i blob oltre la finestra di compliance.
resource "azurerm_storage_management_policy" "audit" {
  count = var.audit_export_enabled ? 1 : 0

  storage_account_id = azurerm_storage_account.audit[0].id

  rule {
    name    = "delete-after-compliance-window"
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
