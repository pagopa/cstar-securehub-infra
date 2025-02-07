#
# Public DNS Zone
#

resource "azurerm_dns_zone" "public" {
  count = (var.dns_zone_prefix == null || var.external_domain == null) ? 0 : 1

  name                = join(".", [var.dns_zone_prefix, var.external_domain])
  resource_group_name = azurerm_resource_group.rg_vnet.name
  tags                = var.tags
}

# application gateway records
resource "azurerm_dns_a_record" "dns_a_apim" {
  for_each = toset(["api", "portal", "management"])

  name                = each.key
  zone_name           = azurerm_dns_zone.public[0].name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  ttl                 = var.dns_default_ttl_sec
  records             = [azurerm_public_ip.appgateway_public_ip.ip_address]
  tags                = var.tags
}

# application gateway MTLS record
resource "azurerm_dns_a_record" "dns_a_apim_mtls" {
  name                = "api-mtls"
  zone_name           = azurerm_dns_zone.public[0].name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  ttl                 = var.dns_default_ttl_sec
  records             = [azurerm_public_ip.appgateway_public_ip.ip_address]
  tags                = var.tags
}


resource "azurerm_dns_caa_record" "cstar_pagopa_it_ns_caa" {
  name                = "@"
  zone_name           = azurerm_dns_zone.public[0].name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  ttl                 = var.dns_default_ttl_sec

  record {
    flags = 0
    tag   = "issue"
    value = "letsencrypt.org"
  }

  record {
    flags = 0
    tag   = "issue"
    value = "digicert.com"
  }
  record {
    flags = 0
    tag   = "iodef"
    value = "mailto:security+caa@pagopa.it"
  }

  tags = var.tags
}

#
# Public IP
#

# Application gateway
resource "azurerm_public_ip" "appgateway_public_ip" {
  name                = "${local.project}-appgateway-pip"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  sku                 = "Standard"
  allocation_method   = "Static"
  zones               = var.zones

  tags = var.tags
}

# API management
resource "azurerm_public_ip" "apim_public_ip" {
  name                = format("%s-apim-pip", local.project)
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  sku                 = "Standard"
  domain_name_label   = "apimcstar${var.env}"
  allocation_method   = "Static"
  zones               = var.zones

  tags = var.tags
}

#
# Dns Delegation
#

# Prod ONLY record to DEV public DNS delegation
resource "azurerm_dns_ns_record" "dev_cstar_pagopa_it_ns" {
  count = var.env_short == "p" ? 1 : 0

  name                = "dev"
  zone_name           = azurerm_dns_zone.public[0].name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  records = [
    "ns1-37.azure-dns.com.",
    "ns2-37.azure-dns.net.",
    "ns3-37.azure-dns.org.",
    "ns4-37.azure-dns.info.",
  ]
  ttl  = var.dns_default_ttl_sec
  tags = var.tags
}

# Prod ONLY record to UAT public DNS delegation
resource "azurerm_dns_ns_record" "uat_cstar_pagopa_it_ns" {
  count = var.env_short == "p" ? 1 : 0

  name                = "uat"
  zone_name           = azurerm_dns_zone.public[0].name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  records = [
    "ns1-34.azure-dns.com.",
    "ns2-34.azure-dns.net.",
    "ns3-34.azure-dns.org.",
    "ns4-34.azure-dns.info.",
  ]
  ttl  = var.dns_default_ttl_sec
  tags = var.tags
}