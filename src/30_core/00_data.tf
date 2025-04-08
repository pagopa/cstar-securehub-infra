#
# 🔐 KV
#
data "azurerm_resource_group" "sec_rg" {
  name = "${local.project}-sec-rg"
}

data "azurerm_key_vault" "core_kvs" {

  for_each = toset(local.core_kv_prefix_names)

  name                = "${local.product}-${each.key}-kv"
  resource_group_name = local.rg_name_core_security
}

# INFRA OpsGenie Cstar_Azure_infra_prod webhook key
data "azurerm_key_vault_secret" "opsgenie_cstar_infra_webhook_key" {
  count = var.env_short == "p" ? 1 : 0
  name  = "opsgenie-cstar-infra-webhook-token"

  key_vault_id = data.azurerm_key_vault.core_kvs["core"].id
}

data "azurerm_key_vault_secret" "monitor_notification_slack_email" {
  name         = "monitor-notification-slack-email"
  key_vault_id = data.azurerm_key_vault.core_kvs["core"].id
}

data "azurerm_key_vault_secret" "monitor_notification_email" {
  name         = "monitor-notification-email"
  key_vault_id = data.azurerm_key_vault.core_kvs["core"].id
}

#
# 🌐 Networking
#

data "azurerm_subnet" "azdoa_snet" {
  name                 = "${local.project}-hub-azdoa-snet"
  resource_group_name  = local.vnet_hub_resource_group_name
  virtual_network_name = local.vnet_hub_name
}

data "azurerm_subnet" "spoke_data_monitor_workspace_snet" {
  name                 = "${local.project}-monitor-workspace-snet"
  resource_group_name  = local.vnet_hub_resource_group_name
  virtual_network_name = "${local.project}-spoke-data-vnet"
}

data "azurerm_private_dns_zone" "prometheus_dns_zone" {
  name = "privatelink.${var.location}.prometheus.monitor.azure.com"
}

#
# Managed identity
#
data "azurerm_user_assigned_identity" "iac_federated_azdo" {
  for_each            = local.azdo_iac_managed_identities
  name                = each.key
  resource_group_name = local.legacy_managed_identity_resource_group_name
}

#
# Packer
#
data "azurerm_resource_group" "packer_rg" {
  name = local.packer_rg_name
}
