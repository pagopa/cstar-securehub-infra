# resource "azurerm_resource_group" "container_registry_rg" {
#   name     = "${local.project}-container-registry-rg"
#   location = var.location
#
#   tags = var.tags
# }
#
# module "container_registry" {
#   source = "./.terraform/modules/__v4__/container_registry"
#
#   name                          = replace("${local.project}-common-acr", "-", "")
#   sku                           = var.env_short != "d" ? "Premium" : "Basic"
#   resource_group_name           = azurerm_resource_group.container_registry_rg.name
#   admin_enabled                 = true # TODO to change ...
#   anonymous_pull_enabled        = false
#   zone_redundancy_enabled       = var.env_short == "p" ? true : false
#   public_network_access_enabled = true
#   private_endpoint_enabled      = false
#   location                      = var.location
#
#   network_rule_set = [{
#     default_action  = "Allow"
#     ip_rule         = []
#     virtual_network = []
#   }]
#
#   tags = var.tags
# }
