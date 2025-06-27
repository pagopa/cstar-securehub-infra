resource "azurerm_dns_cname_record" "dkim" {
  count = 3

  name                = "${element(module.ses.dkim_tokens, count.index)}._domainkey"
  zone_name           = local.public_dns_zone_name
  resource_group_name = local.vnet_legacy_rg
  ttl                 = 3600
  record              = "${element(module.ses.dkim_tokens, count.index)}.dkim.${var.region}.amazonses.com"

  tags = module.tag_config.tags
}

resource "azurerm_dns_txt_record" "dmarc" {
  name                = "_dmarc"
  zone_name           = local.public_dns_zone_name
  resource_group_name = local.vnet_legacy_rg
  ttl                 = 3600

  record {
    value = "v=DMARC1; p=quarantine; aspf=r; adkim=r; pct=100; fo=1;"
  }
  tags = module.tag_config.tags
}

resource "azurerm_dns_mx_record" "mx" {
  name                = local.ses_username
  zone_name           = local.public_dns_zone_name
  resource_group_name = local.vnet_legacy_rg
  ttl                 = 3600

  record {
    preference = 10
    exchange   = "feedback-smtp.${var.region}.amazonses.com"
  }
}

resource "azurerm_dns_txt_record" "spf" {
  name                = local.ses_username
  zone_name           = local.public_dns_zone_name
  resource_group_name = local.vnet_legacy_rg
  ttl                 = 3600

  record {
    value = "v=spf1 include:amazonses.com -all"
  }
  tags = module.tag_config.tags
}
