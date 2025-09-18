
#
# Event Grid
#
resource "azurerm_eventgrid_system_topic" "idpay_asset_register_storage_topic" {
  name                   = "${local.project}-events-asset-register-storage-topic"
  location               = var.location
  resource_group_name    = data.azurerm_resource_group.idpay_data_rg.name
  source_arm_resource_id = module.storage_idpay_asset.id
  topic_type             = "Microsoft.Storage.StorageAccounts"

  identity {
    type = "SystemAssigned"
  }
  tags = module.tag_config.tags
}

# Assign role to event grid topic to publish over asset_register_storage_topic
resource "azurerm_role_assignment" "event_grid_sender_role_on_asset_register_storage_topic" {
  count                = var.enable.idpay.eventhub_rdb ? 1 : 0
  role_definition_name = "Azure Event Hubs Data Sender"
  principal_id         = azurerm_eventgrid_system_topic.idpay_asset_register_storage_topic.identity[0].principal_id
  scope                = module.event_hub_idpay_rdb_configuration[0].hub_ids["idpay-asset-register"]

  depends_on = [azurerm_eventgrid_system_topic.idpay_asset_register_storage_topic]
}

resource "azurerm_eventgrid_system_topic_event_subscription" "idpay_asset_register_storage_topic_event_subscription" {
  name                = "${local.project}-events-asset-register-storage-subscription"
  system_topic        = azurerm_eventgrid_system_topic.idpay_asset_register_storage_topic.name
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name

  event_delivery_schema = "EventGridSchema"
  eventhub_endpoint_id  = module.event_hub_idpay_rdb_configuration[0].hub_ids["idpay-asset-register"]

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

  advanced_filter {
    string_begins_with {
      key    = "subject"
      values = ["/blobServices/default/containers/asset/blobs/CSV/"]
    }
  }

  retry_policy {
    event_time_to_live    = 1440
    max_delivery_attempts = 30
  }
}
