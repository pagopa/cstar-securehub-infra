locals {
  servicebus_namespace_name = "${local.project}-sb-ns"

  servicebus_queues = {
    idpay-onboarding-request = {
      requires_duplicate_detection            = true
      duplicate_detection_history_time_window = "P1D"
      dead_lettering_on_message_expiration    = true
      authorization_rules = [
        {
          name   = "idpay-onboarding-request-producer"
          listen = false
          send   = true
          manage = false
        },
        {
          name   = "idpay-onboarding-request-processor"
          listen = true
          send   = true
          manage = false
        }
      ]
    }
    idpay-payment-timeout = {
      requires_duplicate_detection            = true
      duplicate_detection_history_time_window = "P1D"
      dead_lettering_on_message_expiration    = true
      authorization_rules = [
        {
          name   = "idpay-payment-timeout-consumer"
          listen = true
          send   = false
          manage = false
        }
      ]
    }
  }

  servicebus_namespace_auth_rules = [
    {
      name   = "idpay-service-bus-ns-manager"
      listen = true
      send   = true
      manage = true
    }
  ]

  servicebus_queue_auth_rules_map = {
    for item in flatten([
      for queue_name, queue in local.servicebus_queues : [
        for rule in queue.authorization_rules : {
          key        = "${queue_name}-${rule.name}"
          queue_name = queue_name
          rule       = rule
        }
      ]
      ]) : item.key => {
      queue_name = item.queue_name
      rule       = item.rule
    }
  }
}

resource "azurerm_servicebus_namespace" "idpay_service_bus_ns" {
  name                          = "${local.project}-sb-ns"
  location                      = var.location
  resource_group_name           = data.azurerm_resource_group.idpay_data_rg.name
  sku                           = var.service_bus_namespace.sku
  minimum_tls_version           = "1.2"
  public_network_access_enabled = true #Mandatory because only the premium SKU supports private endpoints
  tags                          = var.tags
}

resource "azurerm_servicebus_namespace_authorization_rule" "namespace_rules" {
  for_each = { for rule in local.servicebus_namespace_auth_rules : rule.name => rule }

  name         = each.value.name
  namespace_id = azurerm_servicebus_namespace.idpay_service_bus_ns.id

  listen = each.value.listen
  send   = each.value.send
  manage = each.value.manage
}

resource "azurerm_servicebus_queue" "queues" {
  for_each = local.servicebus_queues

  name                                    = each.key
  namespace_id                            = azurerm_servicebus_namespace.idpay_service_bus_ns.id
  requires_duplicate_detection            = each.value.requires_duplicate_detection
  duplicate_detection_history_time_window = each.value.duplicate_detection_history_time_window
  dead_lettering_on_message_expiration    = each.value.dead_lettering_on_message_expiration
}

resource "azurerm_servicebus_queue_authorization_rule" "queue_auth_rules" {
  for_each = local.servicebus_queue_auth_rules_map

  name     = each.value.rule.name
  queue_id = azurerm_servicebus_queue.queues[each.value.queue_name].id

  listen = each.value.rule.listen
  send   = each.value.rule.send
  manage = each.value.rule.manage
}

resource "azurerm_key_vault_secret" "namespace_auth_secrets" {
  for_each = azurerm_servicebus_namespace_authorization_rule.namespace_rules

  name         = "${each.value.name}-sas-key"
  value        = each.value.primary_connection_string
  content_type = "text/plain"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

resource "azurerm_key_vault_secret" "queue_auth_secrets" {
  for_each = azurerm_servicebus_queue_authorization_rule.queue_auth_rules

  name         = "${each.value.name}-sas-key"
  value        = each.value.primary_connection_string
  content_type = "text/plain"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

