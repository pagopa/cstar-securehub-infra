
#
# Event Grid
#
resource "azurerm_eventgrid_system_topic" "idpay_refund_storage_topic" {
  name                   = "${local.project}-events-refund-storage-topic"
  location               = var.location
  resource_group_name    = data.azurerm_resource_group.idpay_data_rg.name
  source_arm_resource_id = module.idpay_refund_storage.id
  topic_type             = "Microsoft.Storage.StorageAccounts"

  identity {
    type = "SystemAssigned"
  }
  tags = module.tag_config.tags
}

# Assign role to event grid topic to publish over refund_storage_topic
resource "azurerm_role_assignment" "event_grid_sender_role_on_refund_storage_topic" {
  count                = var.enable.idpay.eventhub_idpay_01 ? 1 : 0
  role_definition_name = "Azure Event Hubs Data Sender"
  principal_id         = azurerm_eventgrid_system_topic.idpay_refund_storage_topic.identity[0].principal_id
  scope                = module.event_hub_idpay_01_configuration[0].hub_ids["idpay-reward-notification-storage-events"]

  depends_on = [azurerm_eventgrid_system_topic.idpay_refund_storage_topic]
}

resource "azurerm_eventgrid_system_topic_event_subscription" "idpay_refund_storage_topic_event_subscription" {
  name                = "${local.project}-events-refund-storage-subscription"
  system_topic        = azurerm_eventgrid_system_topic.idpay_refund_storage_topic.name
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name

  event_delivery_schema = "EventGridSchema"
  eventhub_endpoint_id  = module.event_hub_idpay_01_configuration[0].hub_ids["idpay-reward-notification-storage-events"]

  delivery_identity {
    type = "SystemAssigned"
  }

  delivery_property {
    header_name  = "PartitionKey"
    type         = "Dynamic"
    source_field = "data.clientRequestId"
    secret       = false
  }

  included_event_types = ["Microsoft.Storage.BlobCreated"]

  retry_policy {
    event_time_to_live    = 1440
    max_delivery_attempts = 30
  }
}

resource "azurerm_role_assignment" "refund_storage_data_contributor" {
  scope                = module.idpay_refund_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_api_management.apim_core.identity[0].principal_id

  depends_on = [
    module.idpay_refund_storage
  ]
}
