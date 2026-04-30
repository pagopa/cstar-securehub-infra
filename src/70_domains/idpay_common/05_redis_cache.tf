module "redis_v2" {
  source = "./.terraform/modules/__v4__/IDH/redis"

  # General
  product_name        = var.prefix
  env                 = var.env
  location            = var.location
  resource_group_name = local.data_rg
  tags                = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = "basic"

  # Redis Settings
  name = "${local.project}-v2-redis"

  # Network

  embedded_subnet = {
    enabled              = true
    vnet_name            = local.vnet_spoke_data_name
    vnet_rg_name         = local.core_network_rg
    private_dns_zone_ids = [data.azurerm_private_dns_zone.redis.id]
  }
}

module "redis" {
  source = "./.terraform/modules/__v4__/IDH/managed_redis"

  # General
  product_name        = var.prefix
  env                 = var.env
  location            = var.location
  resource_group_name = local.data_rg
  tags                = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = "balanced_0_5gb"

  # Redis Settings
  name = local.project

  # Network

  embedded_subnet = {
    enabled              = true
    vnet_name            = local.vnet_spoke_data_name
    vnet_rg_name         = local.core_network_rg
    private_dns_zone_ids = [data.azurerm_private_dns_zone.managed_redis.id]
  }

  alert_action_group_ids = [
    var.env_short == "p" ? data.azurerm_monitor_action_group.alerts_opsgenie[0].id : null
  ]
}

#
# 🔑 KV
#
locals {
  redis_kv_values = {
    "idpay-redis-primary-connection-string"   = module.redis.primary_access_key
    "idpay-redis-primary-connection-url"      = module.redis.primary_connection_url
    "idpay-redis-secondary-connection-string" = module.redis.secondary_access_key
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
