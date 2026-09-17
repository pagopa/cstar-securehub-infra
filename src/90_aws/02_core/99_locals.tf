locals {
  product = "${var.prefix}-${var.env_short}"

  domain_prefix = var.env != "prod" ? "${var.env}." : ""

  vnet_legacy_rg = "${local.product}-${var.location_short}-core-network-rg"

  ## SMTP settings for Amazon SES
  ses_username  = "noreply"
  ses_smtp_host = "email-smtp.${var.aws_region}.amazonaws.com"
  ses_smtp_port = 465

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
}
