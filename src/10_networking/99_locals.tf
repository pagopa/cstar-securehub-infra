locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product          = "${var.prefix}-${var.env_short}"
  product_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"

  tags_for_private_dns = { "PrivateDns" = "true" }

  tags_for_mc = merge(var.tags, {
    "domain" = "mc"
  })

  # # Dns Forwarder
  # dns_forwarder_vm_image_name = "${local.product_nodomain}-packer-dns-forwarder-ubuntu2204-image-${var.dns_forwarder_vm_image_version}"
}
