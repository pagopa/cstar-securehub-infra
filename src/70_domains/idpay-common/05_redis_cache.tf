# module "mil_redis" {
#   source = "./.terraform/modules/__v4__/redis_cache"

#   name                  = "${local.project}-redis"
#   location              = azurerm_resource_group.redis_rg.location
#   resource_group_name   = azurerm_resource_group.redis_rg.name
#   capacity              = var.redis_params.capacity
#   enable_non_ssl_port   = false
#   family                = var.redis_params.family
#   sku_name              = var.redis_params.sku_name
#   enable_authentication = true
#   redis_version         = "6"
#   public_network_access_enabled = false

#   private_endpoint = {
#     enabled              = true
#     virtual_network_id   = data.azurerm_virtual_network.vnet_core.id
#     subnet_id            = module.redis_mil_snet.id
#     private_dns_zone_ids = [data.azurerm_private_dns_zone.privatelink_redis.id]
#   }

#   zones = [1, 2, 3]

#   tags = var.tags
# }

# resource "azurerm_key_vault_secret" "idpay_redis_00_primary_connection_string" {
#   name         = "idpay-redis-00-primary-connection-string"
#   value        = module.idpay_redis_00.primary_connection_string
#   content_type = "text/plain"

#   key_vault_id = module.key_vault_idpay.id
# }

# resource "azurerm_key_vault_secret" "idpay_redis_00_primary_connection_url" {
#   name         = "idpay-redis-00-primary-connection-url"
#   value        = "rediss://:${module.idpay_redis_00.primary_access_key}@${module.idpay_redis_00.hostname}:${module.idpay_redis_00.ssl_port}"
#   content_type = "text/plain"

#   key_vault_id = module.key_vault_idpay.id
# }
