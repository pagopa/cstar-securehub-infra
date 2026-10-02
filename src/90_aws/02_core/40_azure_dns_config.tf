# # Publishes the 3 CNAME DKIM records required by Amazon SES for domain authentication
# resource "azurerm_dns_cname_record" "dkim" {
#   count = 3
#
#   name                = "${element(module.ses.dkim_tokens, count.index)}._domainkey"
#   zone_name           = local.public_dns_zone_name
#   resource_group_name = local.vnet_legacy_rg
#   ttl                 = 3600
#   record              = "${element(module.ses.dkim_tokens, count.index)}.dkim.amazonses.com"
#   tags                = module.tag_config.tags
# }
#
# # Publishes the DMARC policy for this domain (quarantine on authentication failure)
# resource "azurerm_dns_txt_record" "dmarc" {
#   name                = "_dmarc"
#   zone_name           = local.public_dns_zone_name
#   resource_group_name = local.vnet_legacy_rg
#   ttl                 = 3600
#
#   record {
#     value = "v=DMARC1; p=quarantine; aspf=r; adkim=r; pct=100; fo=1;"
#   }
#   tags = module.tag_config.tags
# }
#
# # Publishes the MX record for the custom MAIL FROM domain, required by SES
# resource "azurerm_dns_mx_record" "mx" {
#   name                = local.ses_username
#   zone_name           = local.public_dns_zone_name
#   resource_group_name = local.vnet_legacy_rg
#   ttl                 = 3600
#
#   record {
#     preference = 10
#     exchange   = "feedback-smtp.${var.aws_region}.amazonses.com"
#   }
# }
#
# # Publishes the SPF record for the custom MAIL FROM domain, authorizing only Amazon SES to send emails
# resource "azurerm_dns_txt_record" "spf" {
#   name                = local.ses_username
#   zone_name           = local.public_dns_zone_name
#   resource_group_name = local.vnet_legacy_rg
#   ttl                 = 3600
#
#   record {
#     value = "v=spf1 include:amazonses.com -all"
#   }
#   tags = module.tag_config.tags
# }

#----------------------------------------------------------------------------------------------------

# Publishes the 3 CNAME DKIM records required by Amazon SES for domain authentication
resource "azurerm_dns_cname_record" "aws_dkim" {
  for_each = merge([
    for key, value in local.ses_domains : {
      for index, token in module.aws_ses[key].dkim_tokens : "${key}-${index}" => {
        zone  = key
        token = token
      }
    }
  ]...)

  name                = "${each.value.token}._domainkey"
  zone_name           = each.value.zone
  resource_group_name = local.vnet_legacy_rg
  ttl                 = 3600
  record              = "${each.value.token}.dkim.amazonses.com"
  tags                = module.tag_config.tags
}

# Publishes the SPF record for the custom MAIL FROM domain, authorizing only Amazon SES to send emails
resource "azurerm_dns_txt_record" "aws_spf" {
  for_each = local.ses_domains

  name                = local.ses_username
  zone_name           = each.key
  resource_group_name = local.vnet_legacy_rg
  ttl                 = 3600

  record {
    value = "v=spf1 include:amazonses.com -all"
  }
  tags = module.tag_config.tags
}

resource "azurerm_dns_mx_record" "aws_mx" {
  for_each = local.ses_domains

  name                = local.ses_username
  zone_name           = each.key
  resource_group_name = local.vnet_legacy_rg
  ttl                 = 3600

  record {
    preference = 10
    exchange   = "feedback-smtp.${var.aws_region}.amazonses.com"
  }
}

# Publishes the DMARC policy for this domain (quarantine on authentication failure)
resource "azurerm_dns_txt_record" "aws_dmarc" {
  for_each = local.ses_domains

  name                = "_dmarc"
  zone_name           = each.key
  resource_group_name = local.vnet_legacy_rg
  ttl                 = 3600

  record {
    value = "v=DMARC1; p=quarantine; aspf=r; adkim=r; pct=100; fo=1;"
  }
  tags = module.tag_config.tags
}
