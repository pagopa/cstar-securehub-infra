### 🌐 Admin Web Interface — hosting sito statico su Blob Storage (solo VPN)
#
# Requisito: esporre un'interfaccia web di amministrazione accessibile SOLO
# attraverso la VPN aziendale, senza esposizione pubblica su internet, garantendo
# isolamento di rete e sicurezza tramite private endpoint.
#

# Storage Account Static Website
module "admin_web_storage" {
  count  = var.env_short == "d" ? 1 : 0
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

  resource_group_nsg_name = local.network_rg

  embedded_subnet = {
    enabled      = true
    vnet_name    = local.vnet_spoke_data_name
    vnet_rg_name = local.vnet_network_rg
  }

  # Private Endpoint del sito web
  private_dns_zone_web_ids  = [data.azurerm_private_dns_zone.web_storage[0].id]
  private_dns_zone_blob_ids = [data.azurerm_private_dns_zone.blob_storage.id]

  # Static Website
  index_document     = "index.html"
  error_404_document = "index.html"

}
