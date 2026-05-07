module "managed_redis" {
  source = "./.terraform/modules/__v4__/IDH/managed_redis"

  # General
  product_name        = var.prefix
  env                 = var.env
  location            = var.location
  resource_group_name = local.data_rg_name
  tags                = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = var.env_short != "p" ? "balanced_0_5gb" : "balanced_1gb"

  # Redis Settings
  name = local.project

  # Network

  embedded_subnet = {
    enabled              = true
    vnet_name            = local.vnet_spoke_data_name
    vnet_rg_name         = local.network_rg
    private_dns_zone_ids = [data.azurerm_private_dns_zone.managed_redis.id]
  }

  alert_action_group_ids = []
}

#
# 🔑 KV
#
locals {
  redis_kv_values = {
    "srtp-redis-primary-connection-string"   = module.managed_redis.primary_access_key
    "srtp-redis-primary-connection-url"      = module.managed_redis.primary_connection_url
    "srtp-redis-secondary-connection-string" = module.managed_redis.secondary_access_key
    # The double “s” in rediss:// for TLS is not a typo.
    "srtp-redis-secondary-connection-url" = module.managed_redis.secondary_connection_url
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
