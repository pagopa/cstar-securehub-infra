locals {
  jaas_config_template_emd = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"%s\";"
}

module "eventhub_namespace" {
  source = "./.terraform/modules/__v4__/IDH/event_hub"

  env                 = var.env
  idh_resource_tier   = "standard_private"
  location            = var.location
  name                = "${local.project}-evh"
  product_name        = var.prefix
  resource_group_name = data.azurerm_resource_group.mdc_data_rg.name

  embedded_subnet = {
    enabled      = true
    vnet_rg_name = local.vnet_network_rg
    vnet_name    = local.vnet_spoke_data_name
  }
  private_endpoint_resource_group_name = data.azurerm_resource_group.mdc_data_rg.name
  private_dns_zones_ids                = [data.azurerm_private_dns_zone.eventhub.id]

  tags = module.tag_config.tags
}

module "eventhub_configuration" {
  source = "./.terraform/modules/__v4__/eventhub_configuration"

  event_hub_namespace_name                = module.eventhub_namespace.name
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
  for_each = module.eventhub_configuration.key_ids

  name         = format("evh-%s-%s-emd", replace(each.key, ".", "-"), "jaas-config")
  value        = format(local.jaas_config_template_emd, module.eventhub_configuration.keys[each.key].primary_connection_string)
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_domain.id

  tags = module.tag_config.tags
}
