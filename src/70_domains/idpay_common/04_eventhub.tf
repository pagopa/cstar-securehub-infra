locals {
  jaas_config_template_idpay = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"%s\";"
  eventhub_castore_name        = "${local.project}-evh-castore-ns"
  eventhub_polluce_name        = "${local.project}-evh-polluce-ns"
}

#
# 🅒 Event Hub Namespace for IDPay
#
module "eventhub_namespace_idpay_castore" {

  count = var.env == "dev" ? 1 : 0

  source = "./.terraform/modules/__v4__/eventhub"
  # source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//eventhub?ref=PAYMCLOUD-344-v-4-event-hub-revisione-modulo-v-4"

  name                     = local.eventhub_castore_name
  location                 = var.location
  resource_group_name      = data.azurerm_resource_group.idpay_data_rg.name
  auto_inflate_enabled     = var.ehns_auto_inflate_enabled
  sku                      = var.ehns_sku_name
  capacity                 = var.ehns_capacity
  maximum_throughput_units = var.ehns_maximum_throughput_units

  private_endpoint_created             = true
  private_endpoint_resource_group_name = module.idpay_eventhub_snet.resource_group_name
  private_endpoint_subnet_id           = module.idpay_eventhub_snet.id

  # eventhubs = var.eventhubs_idpay_00

  private_dns_zones = {
    id                  = [data.azurerm_private_dns_zone.eventhub.id]
    name                = [data.azurerm_private_dns_zone.eventhub.name]
    resource_group_name = data.azurerm_private_dns_zone.eventhub.resource_group_name,
  }

  private_dns_zone_record_A_name = local.eventhub_castore_name

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
    # {
    #   default_action                 = "Deny"
    #   trusted_service_access_enabled = true
    #   virtual_network_rule = [
    #     # {
    #     #   subnet_id                                       = data.azurerm_subnet.eventhub_snet.id
    #     #   ignore_missing_virtual_network_service_endpoint = false
    #     # },
    #     # {
    #     #   subnet_id                                       = data.azurerm_subnet.aks_domain_subnet.id
    #     #   ignore_missing_virtual_network_service_endpoint = false
    #     # },
    #     # {
    #     #   subnet_id                                       = data.azurerm_subnet.private_endpoint_snet.id
    #     #   ignore_missing_virtual_network_service_endpoint = false
    #     # }
    #   ]
    #   ip_rule = []
    # }
  ]

  tags = var.tags
}

module "event_hub_idpay_castore_configuration" {
  count = var.env == "dev" ? 1 : 0

  source = "./.terraform/modules/__v4__/eventhub_configuration"
  # source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//eventhub_configuration?ref=PAYMCLOUD-344-v-4-event-hub-revisione-modulo-v-4"

  event_hub_namespace_name                = module.eventhub_namespace_idpay_castore[0].name
  event_hub_namespace_resource_group_name = module.eventhub_namespace_idpay_castore[0].resource_group_name

  eventhubs = var.eventhubs_idpay

  depends_on = [
    module.eventhub_namespace_idpay_castore
  ]
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "event_hub_idpay_castore_primary_connection_string" {
  for_each = var.env == "dev" ? module.event_hub_idpay_castore_configuration[0].key_ids : {}

  name         = format("evh-%s-%s-idpay-castore", replace(each.key, ".", "-"), "jaas-config")
  value        = format(local.jaas_config_template_idpay, module.event_hub_idpay_castore_configuration[0].keys[each.key].primary_connection_string)
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.domain_kv.id
}


#
# 🅿 Event Hub Namespace for IDPay
#
module "eventhub_namespace_idpay_polluce" {

  count = var.env == "dev" ? 1 : 0

  source = "./.terraform/modules/__v4__/eventhub"
  # source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//eventhub?ref=PAYMCLOUD-344-v-4-event-hub-revisione-modulo-v-4"

  name                     = local.eventhub_polluce_name
  location                 = var.location
  resource_group_name      = data.azurerm_resource_group.idpay_data_rg.name
  auto_inflate_enabled     = var.ehns_auto_inflate_enabled
  sku                      = var.ehns_sku_name
  capacity                 = var.ehns_capacity
  maximum_throughput_units = var.ehns_maximum_throughput_units

  private_endpoint_created             = true
  private_endpoint_resource_group_name = module.idpay_eventhub_snet.resource_group_name
  private_endpoint_subnet_id           = module.idpay_eventhub_snet.id

  # eventhubs = var.eventhubs_idpay_00

  private_dns_zones = {
    id                  = [data.azurerm_private_dns_zone.eventhub.id]
    name                = [data.azurerm_private_dns_zone.eventhub.name]
    resource_group_name = data.azurerm_private_dns_zone.eventhub.resource_group_name,
  }

  private_dns_zone_record_A_name = local.eventhub_polluce_name

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
    # {
    #   default_action                 = "Deny"
    #   trusted_service_access_enabled = true
    #   virtual_network_rule = [
    #     # {
    #     #   subnet_id                                       = data.azurerm_subnet.eventhub_snet.id
    #     #   ignore_missing_virtual_network_service_endpoint = false
    #     # },
    #     # {
    #     #   subnet_id                                       = data.azurerm_subnet.aks_domain_subnet.id
    #     #   ignore_missing_virtual_network_service_endpoint = false
    #     # },
    #     # {
    #     #   subnet_id                                       = data.azurerm_subnet.private_endpoint_snet.id
    #     #   ignore_missing_virtual_network_service_endpoint = false
    #     # }
    #   ]
    #   ip_rule = []
    # }
  ]

  tags = var.tags
}

module "event_hub_idpay_polluce_configuration" {
  count = var.env == "dev" ? 1 : 0

  source = "./.terraform/modules/__v4__/eventhub_configuration"
  # source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//eventhub_configuration?ref=PAYMCLOUD-344-v-4-event-hub-revisione-modulo-v-4"

  event_hub_namespace_name                = module.eventhub_namespace_idpay_polluce[0].name
  event_hub_namespace_resource_group_name = module.eventhub_namespace_idpay_polluce[0].resource_group_name

  eventhubs = var.eventhubs_idpay_01

  depends_on = [
    module.eventhub_namespace_idpay_polluce
  ]
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "event_hub_idpay_polluce_primary_connection_string" {
  for_each = var.env == "dev" ? module.event_hub_idpay_polluce_configuration[0].key_ids : {}

  name         = format("evh-%s-%s-idpay-polluce", replace(each.key, ".", "-"), "jaas-config")
  value        = format(local.jaas_config_template_idpay, module.event_hub_idpay_polluce_configuration[0].keys[each.key].primary_connection_string)
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.domain_kv.id
}
