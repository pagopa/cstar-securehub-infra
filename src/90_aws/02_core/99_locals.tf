locals {
  product = "${var.prefix}-${var.env_short}"

  ses_domain = var.env != "prod" ? "${var.env}.${var.prefix}.pagopa.it" : "${var.prefix}.pagopa.it"

  public_dns_zone_name = var.env != "prod" ? "${var.env}.${var.prefix}.pagopa.it" : "${var.prefix}.pagopa.it"
  vnet_legacy_rg       = "${local.product}-vnet-rg"

  ses_username = "noreply"


  tags = {
    for key, value in module.tag_config.tags : key => replace(value, "&", "e")
  }
}
