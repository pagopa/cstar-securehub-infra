locals {
  product = "${var.prefix}-${var.env_short}"

  public_dns_zone_name = var.env != "prod" ? "${var.env}.${var.prefix}.pagopa.it" : "${var.prefix}.pagopa.it"

  vnet_legacy_rg = "${local.product}-vnet-rg"

  ## SMTP settings for Amazon SES
  iam_ses_user      = "${var.prefix}-${var.env}-ses-user"
  ses_domain        = var.env != "prod" ? "${var.env}.bonuselettrodomestici.pagopa.it" : "bonuselettrodomestici.pagopa.it"
  ses_username      = "noreply"
  ses_smtp_host     = "email-smtp.${var.aws_region}.amazonaws.com"
  ses_smtp_port     = 465
  ses_from_address  = "${local.ses_username}@${local.ses_domain}"
  ses_mail_from_dom = aws_ses_domain_mail_from.noreply.mail_from_domain

  tags = {
    for key, value in module.tag_config.tags : key => replace(value, "&", "e")
  }
}
