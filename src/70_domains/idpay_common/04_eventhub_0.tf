locals {
  jaas_config_template_idpay = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"%s\";"
  eventhub_00_name           = "${local.project}-evh-00-ns"
  eventhub_01_name           = "${local.project}-evh-01-ns"
  eventhub_rdb_name          = "${local.project}-evh-rdb-ns"
}

#
# 🅒 Event Hub Namespace for IDPay
#
module "eventhub_namespace_idpay_00" {
  source = "./.terraform/modules/__v4__/eventhub"

  name                     = local.eventhub_00_name
  location                 = var.location
  resource_group_name      = data.azurerm_resource_group.idpay_data_rg.name
  auto_inflate_enabled     = var.ehns_auto_inflate_enabled
  sku                      = var.ehns_sku_name
  capacity                 = var.ehns_capacity
  maximum_throughput_units = var.ehns_maximum_throughput_units

  private_endpoint_created             = true
  private_endpoint_resource_group_name = module.private_endpoint_eventhub_snet.resource_group_name
  private_endpoint_subnet_id           = module.private_endpoint_eventhub_snet.id
  private_dns_zones_ids                = [data.azurerm_private_dns_zone.eventhub.id]

  alerts_enabled = var.ehns_alerts_enabled
  metric_alerts  = var.ehns_metric_alerts
  # action = [
  #   {
  #     action_group_id    = local.monitor_action_group_email_name
  #     webhook_properties = null
  #   },
  #   {
  #     action_group_id    = local.monitor_action_group_email_name
  #     webhook_properties = null
  #   }
  # ]

  network_rulesets = [
    {
      default_action                 = "Allow"
      trusted_service_access_enabled = true
      virtual_network_rule           = []
      ip_rule                        = []
    }
  ]

  tags = module.tag_config.tags
}

module "event_hub_idpay_00_configuration" {
  source = "./.terraform/modules/__v4__/eventhub_configuration"

  event_hub_namespace_name                = module.eventhub_namespace_idpay_00.name
  event_hub_namespace_resource_group_name = module.eventhub_namespace_idpay_00.resource_group_name

  eventhubs = local.eventhubs_idpay_00

  depends_on = [
    module.eventhub_namespace_idpay_00
  ]
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "event_hub_idpay_00_primary_connection_string" {
  for_each = module.event_hub_idpay_00_configuration.key_ids

  name         = format("evh-%s-%s-idpay-00", replace(each.key, ".", "-"), "jaas-config")
  value        = format(local.jaas_config_template_idpay, module.event_hub_idpay_00_configuration.keys[each.key].primary_connection_string)
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.domain_kv.id

  tags = module.tag_config.tags
}


#
# 🅿 Event Hub Namespace for IDPay
#
module "eventhub_namespace_idpay_01" {
  source = "./.terraform/modules/__v4__/eventhub"

  count = var.enable.idpay.eventhub_idpay_01 ? 1 : 0

  name                     = local.eventhub_01_name
  location                 = var.location
  resource_group_name      = data.azurerm_resource_group.idpay_data_rg.name
  auto_inflate_enabled     = var.ehns_auto_inflate_enabled
  sku                      = var.ehns_sku_name
  capacity                 = var.ehns_capacity
  maximum_throughput_units = var.ehns_maximum_throughput_units

  private_endpoint_created             = true
  private_endpoint_resource_group_name = module.private_endpoint_eventhub_snet.resource_group_name
  private_endpoint_subnet_id           = module.private_endpoint_eventhub_snet.id
  private_dns_zones_ids                = [data.azurerm_private_dns_zone.eventhub.id]

  alerts_enabled = var.ehns_alerts_enabled
  metric_alerts  = var.ehns_metric_alerts
  # action = [
  #   {
  #     action_group_id    = local.monitor_action_group_email_name
  #     webhook_properties = null
  #   },
  #   {
  #     action_group_id    = local.monitor_action_group_email_name
  #     webhook_properties = null
  #   }
  # ]

  network_rulesets = [
    {
      default_action                 = "Allow"
      trusted_service_access_enabled = true
      virtual_network_rule           = []
      ip_rule                        = []
    }
  ]

  tags = module.tag_config.tags
}

module "event_hub_idpay_01_configuration" {
  count = var.enable.idpay.eventhub_idpay_01 ? 1 : 0

  source = "./.terraform/modules/__v4__/eventhub_configuration"

  event_hub_namespace_name                = module.eventhub_namespace_idpay_01[0].name
  event_hub_namespace_resource_group_name = module.eventhub_namespace_idpay_01[0].resource_group_name

  eventhubs = local.eventhubs_idpay_01

  depends_on = [
    module.eventhub_namespace_idpay_01
  ]
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "event_hub_idpay_01_primary_connection_string" {
  for_each = module.event_hub_idpay_01_configuration[0].key_ids

  name         = format("evh-%s-%s-idpay-01", replace(each.key, ".", "-"), "jaas-config")
  value        = format(local.jaas_config_template_idpay, module.event_hub_idpay_01_configuration[0].keys[each.key].primary_connection_string)
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.domain_kv.id

  tags = module.tag_config.tags
}


#
# 🅒 Event Hub Namespace for IDPay rdb
#
module "eventhub_namespace_rdb" {
  source = "./.terraform/modules/__v4__/eventhub"

  count = var.enable.idpay.eventhub_rdb ? 1 : 0

  name                     = local.eventhub_rdb_name
  location                 = var.location
  resource_group_name      = data.azurerm_resource_group.idpay_data_rg.name
  auto_inflate_enabled     = var.ehns_auto_inflate_enabled
  sku                      = var.ehns_sku_name
  capacity                 = var.ehns_capacity
  maximum_throughput_units = var.ehns_maximum_throughput_units

  private_endpoint_created             = true
  private_endpoint_resource_group_name = module.private_endpoint_eventhub_snet.resource_group_name
  private_endpoint_subnet_id           = module.private_endpoint_eventhub_snet.id
  private_dns_zones_ids                = [data.azurerm_private_dns_zone.eventhub.id]

  alerts_enabled = var.ehns_alerts_enabled
  metric_alerts  = var.ehns_metric_alerts
  # action = [
  #   {
  #     action_group_id    = local.monitor_action_group_email_name
  #     webhook_properties = null
  #   },
  #   {
  #     action_group_id    = local.monitor_action_group_email_name
  #     webhook_properties = null
  #   }
  # ]

  network_rulesets = [
    {
      default_action                 = "Allow"
      trusted_service_access_enabled = true
      virtual_network_rule           = []
      ip_rule                        = []
    }
  ]

  tags = module.tag_config.tags
}

module "event_hub_idpay_rdb_configuration" {
  source = "./.terraform/modules/__v4__/eventhub_configuration"
  count  = var.enable.idpay.eventhub_rdb ? 1 : 0

  event_hub_namespace_name                = module.eventhub_namespace_rdb[0].name
  event_hub_namespace_resource_group_name = module.eventhub_namespace_rdb[0].resource_group_name

  eventhubs = local.eventhubs_rdb

  depends_on = [
    module.eventhub_namespace_rdb
  ]
}


#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "event_hub_idpay_rdb_primary_connection_string" {
  for_each = module.event_hub_idpay_rdb_configuration[0].key_ids

  name         = format("evh-%s-%s-idpay-rdb", replace(each.key, ".", "-"), "jaas-config")
  value        = format(local.jaas_config_template_idpay, module.event_hub_idpay_rdb_configuration[0].keys[each.key].primary_connection_string)
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.domain_kv.id

  tags = module.tag_config.tags
}
