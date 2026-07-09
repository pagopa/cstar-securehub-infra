### 🌐 Admin Web Interface — hosting sito statico su Blob Storage (solo VPN)
#
# Requisito: esporre un'interfaccia web di amministrazione accessibile SOLO
# attraverso la VPN aziendale, senza esposizione pubblica su internet, garantendo
# isolamento di rete e sicurezza tramite private endpoint.
#
# Strategia (massima sicurezza):
#   1) Storage Account creato tramite il modulo standard IDH/storage_account
#      (tier "basic"): gestisce in automatico private endpoint, accesso
#      pubblico DISABILITATO, TLS 1.2.
#   2) Static Website hosting: i file HTML/JS/CSS vengono serviti direttamente
#      dallo storage senza necessità di Web App o CDN, riducendo costi e
#      complessità operativa.
#   3) Private Endpoint sul subresource "web": collega lo storage alla VNet
#      aziendale tramite subnet dedicata, rendendo il sito raggiungibile
#      esclusivamente dalla rete privata aziendale (VPN, VNet o reti peered),
#      senza esposizione pubblica su Internet.
#   4) DNS privato: la zona "privatelink.web.core.windows.net" risolve il FQDN
#      dello storage verso l'IP privato del private endpoint, garantendo che
#      anche le richieste DNS non escano dalla rete aziendale.
#   5) Replicazione storage: ZRS (Zone-Redundant) in prod per alta disponibilità
#      su zone AZ multiple; LRS (Locally-Redundant) in dev/uat per risparmio.
#
# SPA Routing: index.html configurato sia come homepage che come pagina 404
# permette il corretto funzionamento del client-side routing (es. React Router,
# Vue Router) senza necessità di server-side rewrites.
#
# Accesso: gli utenti devono essere connessi alla VPN aziendale o trovarsi nella
# rete privata (es. VM peered alla VNet) per raggiungere https://<storage>.web.core.windows.net




# Private DNS Zone per Static Website

# Azure Static Website utilizza il subresource "web"
# con Private DNS Zone privatelink.web.core.windows.net
# mentre Blob Storage utilizza privatelink.blob.core.windows.net
resource "azurerm_private_dns_zone" "web_storage" {
  name                = "privatelink.web.core.windows.net"
  resource_group_name = local.vnet_legacy_resource_group_name
}

# Link Private DNS Zone -> VNet

# Link della Private DNS Zone alla VNet utilizzata
# dalla connettività privata (VPN / peering).
# Permette ai client interni di risolvere il Private Endpoint.
resource "azurerm_private_dns_zone_virtual_network_link" "web_storage" {
  name                  = "web-storage-private-dns-link"
  resource_group_name   = local.vnet_legacy_resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.web_storage.name

  virtual_network_id = data.azurerm_virtual_network.vnet_spoke_data.id

  registration_enabled = false
}

# Storage Account Static Website

module "admin_web_storage" {
  source = "./.terraform/modules/__v4__/IDH/storage_account"

  # General
  product_name        = var.prefix
  env                 = var.env
  location            = var.location
  resource_group_name = data.azurerm_resource_group.mdc_data_rg.name
  tags                = module.tag_config.tags

  idh_resource_tier = "basic"

  # "-" not allowed in storage account names, so we remove them
  name   = substr(replace("${local.admin_web_storage_name}", "-", ""), 0, 24)
  domain = var.domain
  # replication_type = var.web_storage_account_replication_type

  resource_group_nsg_name = local.network_rg

  embedded_subnet = {
    enabled      = true
    vnet_name    = local.vnet_spoke_data_name
    vnet_rg_name = local.vnet_network_rg
  }

  # Private Endpoint del sito web
  private_dns_zone_web_ids = [azurerm_private_dns_zone.web_storage.id]

  # Static Website
  index_document     = "index.html"
  error_404_document = "index.html"

}
