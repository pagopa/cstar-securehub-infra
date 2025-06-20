module "redis" {
  source = "./.terraform/modules/__v4__/IDH/redis"

  # General
  product_name        = var.prefix
  env                 = var.env
  location            = var.location
  resource_group_name = local.data_rg
  tags                = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = contains(["d", "u"], var.env_short) ? "basic" : "critical"

  # Redis Settings
  name = "${local.project}-redis"

  # Network
  private_endpoint = {
    subnet_id            = module.private_endpoint_redis_snet.id
    private_dns_zone_ids = [data.azurerm_private_dns_zone.redis.id]
  }
}

#
# 🔑 KV
#
locals {
  redis_kv_values = {
    "idpay-redis-primary-connection-string"   = module.redis.primary_connection_string
    "idpay-redis-primary-connection-url"      = module.redis.primary_connection_url
    "idpay-redis-secondary-connection-string" = module.redis.secondary_connection_string
    # The double “s” in rediss:// for TLS is not a typo.
    "idpay-redis-secondary-connection-url" = module.redis.secondary_connection_url
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
