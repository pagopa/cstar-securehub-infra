resource "azurerm_public_ip" "messagi_cortesia_pips" {

  for_each = toset(["alfa"])

  name                = "${local.project}-mc-${each.key}-pip"
  resource_group_name = azurerm_resource_group.rg_network.name
  location            = azurerm_resource_group.rg_network.location
  sku                 = "Standard"
  allocation_method   = "Static"

  tags = local.tags_for_mc
}

resource "azurerm_public_ip" "compute_nat_gateway_pip" {
  for_each = toset([for i in range(var.count_ip_nat) : tostring(i)])

  name                = "${local.project}-compute-natgw-pip-${each.key}"
  location            = azurerm_resource_group.rg_network.location
  resource_group_name = azurerm_resource_group.rg_network.name
  allocation_method   = "Static"

  zones = var.default_zones != null ? var.default_zones : [tostring((each.key) % 3) + 1]

  tags = merge(
    module.tag_config.tags,
    {
      AvailabilityZone = var.default_zones != null ? join(",", var.default_zones) : tostring((each.key) % 3) + 1
    }
  )
}

#----------------------------------------------------------------
# 🔎 DNS Record for Nat Gateway (Only Production)
#----------------------------------------------------------------
resource "azurerm_dns_a_record" "nat_gateway" {
  count = var.env_short == "p" ? 1 : 0

  name                = "out"
  zone_name           = data.azurerm_dns_zone.default.name
  resource_group_name = local.dns_default_zone_rg
  ttl                 = 3600
  records             = [for i in azurerm_public_ip.compute_nat_gateway_pip : i.ip_address]
}
