locals {
  jaas_config_template_emd = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"%s\";"
}

module "eventhub_namespace" {
  source = "./.terraform/modules/__v4__/eventhub"

  count = var.is_feature_enabled.eventhub ? 1 : 0

  name                     = "${local.project}-evh"
  location                 = var.location
  resource_group_name      = data.azurerm_resource_group.mdc_data_rg.name
  auto_inflate_enabled     = var.ehns_auto_inflate_enabled
  sku                      = var.ehns_sku_name
  capacity                 = var.ehns_capacity
  maximum_throughput_units = var.ehns_maximum_throughput_units

  private_endpoint_subnet_id           = module.eventhub_snet.subnet_id
  private_endpoint_created             = var.ehns_private_endpoint_is_present
  private_endpoint_resource_group_name = module.eventhub_snet.resource_group_name

  public_network_access_enabled = var.ehns_public_network_access

  action = [
    {
      action_group_id    = data.azurerm_monitor_action_group.slack.id
      webhook_properties = null
    },
    {
      action_group_id    = data.azurerm_monitor_action_group.email.id
      webhook_properties = null
    }
  ]

  metric_alerts_create = var.ehns_alerts_enabled
  metric_alerts        = var.ehns_metric_alerts

  tags = local.tags
}

module "eventhub_configuration" {
  source = "./.terraform/modules/__v4__/eventhub_configuration"
  count  = var.is_feature_enabled.eventhub ? 1 : 0

  event_hub_namespace_name                = module.eventhub_namespace[0].name
  event_hub_namespace_resource_group_name = data.azurerm_resource_group.mdc_data_rg.name

  eventhubs = [
    {
      name              = "emd-courtesy-message"
      partitions        = 1
      message_retention = 1
      consumers = [
        "emd-courtesy-message-consumer-group"
      ]
      keys = [
        {
          name   = "emd-courtesy-message-producer"
          listen = false
          send   = true
          manage = false
        },
        {
          name   = "emd-courtesy-message-consumer"
          listen = true
          send   = false
          manage = false
        }
      ]
    },
    {
      name              = "emd-notify-error"
      partitions        = 1
      message_retention = 1
      consumers = [
        "emd-notify-error-consumer-group"
      ]
      keys = [
        {
          name   = "emd-notify-error-producer"
          listen = false
          send   = true
          manage = false
        },
        {
          name   = "emd-notify-error-consumer"
          listen = true
          send   = false
          manage = false
        }
      ]
    }
  ]

  depends_on = [
    module.eventhub_namespace
  ]
}

#-----------------------------------------------------------------------------------------------------------------------
# KV
#-----------------------------------------------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "eventhub_primary_connection_strings" {
  for_each = var.is_feature_enabled.eventhub ? module.eventhub_configuration[0].key_ids : {}

  name         = format("evh-%s-%s-emd", replace(each.key, ".", "-"), "jaas-config")
  value        = format(local.jaas_config_template_emd, module.eventhub_configuration[0].keys[each.key].primary_connection_string)
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_domain.id

  tags = local.tags
}
