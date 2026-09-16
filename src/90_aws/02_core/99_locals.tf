locals {
  product = "${var.prefix}-${var.env_short}"

  public_dns_zone_name = var.env != "prod" ? "${var.env}.bonuselettrodomestici.pagopa.it" : "bonuselettrodomestici.pagopa.it"
  domain_prefix        = var.env != "prod" ? "${var.env}." : ""

  vnet_legacy_rg = "${local.product}-${var.location_short}-core-network-rg"

  ## SMTP settings for Amazon SES
  iam_ses_user     = "${var.prefix}-${var.env}-ses-user"
  ses_domain       = var.env != "prod" ? "${var.env}.bonuselettrodomestici.pagopa.it" : "bonuselettrodomestici.pagopa.it"
  ses_username     = "noreply"
  ses_smtp_host    = "email-smtp.${var.aws_region}.amazonaws.com"
  ses_smtp_port    = 465
  ses_from_address = "${local.ses_username}@${local.ses_domain}"


  tags = {
    for key, value in module.tag_config.tags : key => replace(value, "&", "e")
  }

  ses_domains = {
    "${local.domain_prefix}pari.pagopa.it" = {
      domain   = "pari"
      iam_user = "${var.prefix}-${var.env}-ses-pari-user"
    }
    "${local.domain_prefix}bonuselettrodomestici.pagopa.it" = {
      domain   = "bonuselettrodomestici"
      iam_user = "${var.prefix}-${var.env}-ses-user"
    }
  }

  # TO REMOVE
  ses_mail_from_dom = aws_ses_domain_mail_from.aws_noreply["${local.domain_prefix}bonuselettrodomestici.pagopa.it"].mail_from_domain
}
