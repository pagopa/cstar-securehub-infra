# data "azurerm_key_vault" "key_vault" {
#   name                = "${local.project}-kv"
#   resource_group_name = "${local.project}-sec-rg"
# }
#
# data "azuread_application" "vpn_app" {
#   display_name = "${local.product}-app-vpn"
# }

# data "azurerm_resources" "sub_resources" {
#   type          = "Microsoft.Network/privateDnsZones"
#   required_tags = local.tags_for_private_dns
# }