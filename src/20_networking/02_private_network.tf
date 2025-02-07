#
# Private DNS Zone
#

# ->> DNS private: internal.dev.p4pa.pagopa.it

resource "azurerm_private_dns_zone" "internal_p4pa_pagopa_it" {
  name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = merge(
    var.tags,
    local.tags_for_private_dns
  )
}

# ->> Storage Account (blob)  - private dns zone
resource "azurerm_private_dns_zone" "storage_account" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = merge(
    var.tags,
    local.tags_for_private_dns
  )
}

# ->> Storage Account (file)  - private dns zone
resource "azurerm_private_dns_zone" "file_storage_account" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = merge(
    var.tags,
    local.tags_for_private_dns
  )
}

# ->> Cosmos MongoDB  - private dns zone
resource "azurerm_private_dns_zone" "privatelink_mongo_cosmos_azure_com" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = merge(
    var.tags,
    local.tags_for_private_dns
  )
}

# ->> Cosmos Cassandra  - private dns zone
resource "azurerm_private_dns_zone" "privatelink_cassandra_cosmos_azure_com" {
  name                = "privatelink.cassandra.cosmos.azure.com"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = merge(
    var.tags,
    local.tags_for_private_dns
  )
}

# ->> Key Vaults  - private dns zone
resource "azurerm_private_dns_zone" "key_vault_dns" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = merge(
    var.tags,
    local.tags_for_private_dns
  )
}

# ->> Flexible PostgreSql - private dns zone
resource "azurerm_private_dns_zone" "privatelink_postgres_database_azure_com" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = merge(
    var.tags,
    local.tags_for_private_dns
  )
}

# ->> Redis - private dns zone
resource "azurerm_private_dns_zone" "privatelink_redis_cache_windows_net" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = merge(
    var.tags,
    local.tags_for_private_dns
  )
}

resource "azurerm_private_dns_zone" "privatelink_servicebus_windows_net" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = merge(
    var.tags,
    local.tags_for_private_dns
  )
}

resource "azurerm_private_dns_zone_virtual_network_link" "all_to_vnet_core" {
  for_each = { for i, v in data.azurerm_resources.sub_resources.resources : data.azurerm_resources.sub_resources.resources[i].name => v }

  name                  = module.vnet_core.name
  resource_group_name   = split("/", each.value["id"])[4]
  private_dns_zone_name = each.value["name"]
  virtual_network_id    = module.vnet_core.id
  registration_enabled  = false

  tags = var.tags
}
