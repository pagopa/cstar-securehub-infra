#----------------------------------------------------------------
# 🔎 DNS
#----------------------------------------------------------------
# Ingress Private DNS A Record
resource "azurerm_private_dns_a_record" "ingress" {
  name                = "${var.domain}.${var.location_short}"
  zone_name           = local.dns_zone_internal
  resource_group_name = local.vnet_legacy_core_rg
  ttl                 = 3600
  records             = [local.ingress_private_load_balancer_ip]
  tags                = module.tag_config.tags
}
