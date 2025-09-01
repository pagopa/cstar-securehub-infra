locals {
  product = "${var.prefix}-${var.env_short}"
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"

  allow_referers_service_locator = ["https://welfare.${local.dns_zone_name}/portale-esercenti"]

  dns_zone_name = "${var.env != "prod" ? "${var.env}." : ""}${var.prefix}.pagopa.it"

  tags = {
    for key, value in module.tag_config.tags : key => replace(value, "&", "e")
  }
}
