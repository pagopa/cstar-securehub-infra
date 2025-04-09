# data "azurerm_private_dns_zone" "ehub" {
#   name                = "privatelink.servicebus.windows.net"
#   resource_group_name = data.azurerm_virtual_network.vnet_core.resource_group_name
# }
#
# data "azurerm_private_dns_zone" "redis" {
#   name                = "privatelink.redis.cache.windows.net"
#   resource_group_name = "${local.product}-vnet-rg"
# }
#
# data "azurerm_dns_zone" "public" {
#   name                = join(".", [var.dns_zone_prefix, var.external_domain])
#   resource_group_name = local.vnet_core_resource_group_name
# }
