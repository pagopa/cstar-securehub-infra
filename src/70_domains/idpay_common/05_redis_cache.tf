module "redis_v2" {
  source = "./.terraform/modules/__v4__/IDH/redis"

  # General
  product_name        = var.prefix
  env                 = var.env
  location            = var.location
  resource_group_name = local.data_rg
  tags                = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = var.redis_idh_resource_tier

  # Redis Settings
  name = "${local.project}-v2-redis"

  # Network
  embedded_subnet = {
    enabled              = true
    vnet_name            = local.vnet_spoke_data_name
    vnet_rg_name         = local.network_rg
    private_dns_zone_ids = [data.azurerm_private_dns_zone.redis.id]
  }
}

#
# 🔑 KV
#
locals {
  redis_kv_values = {
    "idpay-redis-primary-connection-string"   = module.redis_v2.primary_connection_string
    "idpay-redis-primary-connection-url"      = module.redis_v2.primary_connection_url
    "idpay-redis-secondary-connection-string" = module.redis_v2.secondary_connection_string
    # The double “s” in rediss:// for TLS is not a typo.
    "idpay-redis-secondary-connection-url" = module.redis_v2.secondary_connection_url
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
