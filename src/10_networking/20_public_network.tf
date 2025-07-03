# 🔎 DNS
resource "azurerm_dns_zone" "public" {
  for_each = toset(local.dns_env_public_zones)

  name                = each.key
  resource_group_name = azurerm_resource_group.rg_network.name
  tags                = module.tag_config.tags
}

resource "azurerm_dns_ns_record" "dev_name_servers" {
  for_each = var.env_short == "p" ? toset(local.dns_env_public_zones) : []

  name                = "dev"
  zone_name           = azurerm_dns_zone.public[each.key].name
  resource_group_name = azurerm_resource_group.rg_network.name
  records             = lookup(local.dev_ns_records, each.key)

  ttl  = local.dns_default_ttl_sec
  tags = module.tag_config.tags
}

resource "azurerm_dns_ns_record" "uat_name_servers" {
  for_each = var.env_short == "p" ? toset(local.dns_env_public_zones) : []

  name                = "uat"
  zone_name           = azurerm_dns_zone.public[each.key].name
  resource_group_name = azurerm_resource_group.rg_network.name
  records             = lookup(local.uat_ns_records, each.key)

  ttl  = local.dns_default_ttl_sec
  tags = module.tag_config.tags
}

resource "azurerm_dns_caa_record" "ns_caa" {
  for_each = toset(local.dns_env_public_zones)

  name                = "@"
  zone_name           = azurerm_dns_zone.public[each.key].name
  resource_group_name = azurerm_resource_group.rg_network.name
  ttl                 = local.dns_default_ttl_sec

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

  tags = module.tag_config.tags
}
