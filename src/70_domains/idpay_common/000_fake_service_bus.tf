resource "azurerm_servicebus_namespace" "fake_idpay_service_bus_ns" {
  count = var.env_short == "u" ? 1 : 0

  name                          = "${local.project}-sb-fake-ns"
  location                      = var.location
  resource_group_name           = data.azurerm_resource_group.idpay_data_rg.name
  sku                           = "Premium"
  minimum_tls_version           = "1.2"
  public_network_access_enabled = true
  capacity                      = 1
  premium_messaging_partitions  = 1
  tags                          = module.tag_config.tags
}

resource "azurerm_servicebus_namespace_authorization_rule" "fake_namespace_rules" {
  for_each = var.env_short == "u" ? {
    for rule in local.servicebus_namespace_auth_rules : rule.name => rule
  } : {}

  name         = each.value.name
  namespace_id = azurerm_servicebus_namespace.fake_idpay_service_bus_ns[0].id

  listen = each.value.listen
  send   = each.value.send
  manage = each.value.manage
}

resource "azurerm_servicebus_queue" "fake_queues" {
  for_each = var.env_short == "u" ? local.servicebus_queues : {}

  name                                    = each.key
  namespace_id                            = azurerm_servicebus_namespace.fake_idpay_service_bus_ns[0].id
  requires_duplicate_detection            = each.value.requires_duplicate_detection
  duplicate_detection_history_time_window = each.value.duplicate_detection_history_time_window
  dead_lettering_on_message_expiration    = each.value.dead_lettering_on_message_expiration
}

resource "azurerm_servicebus_queue_authorization_rule" "fake_queue_auth_rules" {
  for_each = var.env_short == "u" ? local.servicebus_queue_auth_rules_map : {}

  name     = each.value.rule.name
  queue_id = azurerm_servicebus_queue.fake_queues[each.value.queue_name].id

  listen = each.value.rule.listen
  send   = each.value.rule.send
  manage = each.value.rule.manage
}
