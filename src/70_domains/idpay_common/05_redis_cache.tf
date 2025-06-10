module "idpay_redis" {
  source = "./.terraform/modules/__v4__/redis_cache"
  # source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//redis_cache?ref=PAYMCLOUD-348-v-4-redis-update"

  name                = "${local.project}-redis"
  location            = data.azurerm_resource_group.idpay_data_rg.location
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  capacity            = var.redis_params.capacity
  family              = var.redis_params.family
  sku_name            = var.redis_params.sku_name
  redis_version       = "6"

  private_endpoint = {
    enabled              = true
    virtual_network_id   = data.azurerm_virtual_network.vnet_spoke_data.id
    subnet_id            = module.idpay_redis_snet.id
    private_dns_zone_ids = [data.azurerm_private_dns_zone.redis.id]
  }

  tags = module.tag_config.tags
}

#
# 🔑 KV
#
locals {
  redis_kv_values = {
    "idpay-redis-primary-connection-string"   = module.idpay_redis.primary_connection_string
    "idpay-redis-primary-connection-url"      = module.idpay_redis.primary_connection_url
    "idpay-redis-secondary-connection-string" = module.idpay_redis.secondary_connection_string
    "idpay-redis-secondary-connection-url"    = "rediss://${module.idpay_redis.secondary_connection_url}"
  }
}

resource "azurerm_key_vault_secret" "secrets_redis" {
  for_each = local.redis_kv_values

  name         = each.key
  value        = each.value
  content_type = "text/plain"
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  tags = module.tag_config.tags
}
