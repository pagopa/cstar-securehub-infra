locals {
  redis_idh_resource_tier = var.redis_sku_name == "Premium" ? "premium" : var.redis_sku_name == "Standard" ? "standard" : "basic"
}

module "redis" {
  source = "./.terraform/modules/__v4__/IDH/redis"

  product_name        = var.prefix
  env                 = var.env
  idh_resource_tier   = local.redis_idh_resource_tier
  location            = var.location
  resource_group_name = data.azurerm_resource_group.mdc_data_rg.name
  tags                = local.tags

  name = "${local.project}-redis"

  private_endpoint = {
    subnet_id            = module.private_endpoint_redis_snet.id
    private_dns_zone_ids = [data.azurerm_private_dns_zone.privatelink_redis.id]
  }
}

locals {
  redis_secret_values = {
    "emd-redis-primary-connection-hostname" = {
      value = module.redis.hostname
      type  = "text/plain"
    }
    "emd-redis-primary-access-key" = {
      value = module.redis.primary_access_key
      type  = "text/plain"
    }
  }
}

resource "azurerm_key_vault_secret" "redis_secrets" {
  for_each = local.redis_secret_values

  name         = each.key
  value        = each.value.value
  content_type = each.value.type

  key_vault_id = data.azurerm_key_vault.kv_domain.id

  tags = local.tags
}
