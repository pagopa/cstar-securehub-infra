#
# 🔐 KV
#

data "azurerm_key_vault" "key_vault" {
  name                = "${local.project}-kv"
  resource_group_name = local.rg_name_core_security
}

data "azurerm_key_vault_secret" "monitor_notification_email" {
  name         = "monitor-notification-email"
  key_vault_id = local.kv_id_core
}

data "azurerm_key_vault_secret" "monitor_notification_slack_email" {
  name         = "alert-error-notification-slack"
  key_vault_id = local.kv_id_core
}

data "azurerm_key_vault_secret" "apim_publisher_email" {
  name         = "apim-publisher-email"
  key_vault_id = local.kv_id_core
}

#
# 🌐 Networking
#

data "azurerm_public_ip" "appgateway_public_ip" {
  name                = "${local.project}-appgateway-pip"
  resource_group_name = local.vnet_resource_group_name
}

data "azurerm_public_ip" "apim_public_ip" {
  name                = "${local.project}-apim-pip"
  resource_group_name = local.vnet_resource_group_name
}

data "azurerm_subnet" "apim_snet" {
  name                 = "${local.project}-apim-snet"
  resource_group_name  = local.vnet_resource_group_name
  virtual_network_name = local.vnet_name
}

data "azurerm_subnet" "appgateway_snet" {
  name                 = "${local.project}-appgateway-snet"
  resource_group_name  = local.vnet_resource_group_name
  virtual_network_name = local.vnet_name
}

data "azurerm_subnet" "azdoa_snet" {
  name                 = "${local.project}-azdoa-snet"
  resource_group_name  = local.vnet_resource_group_name
  virtual_network_name = local.vnet_name
}

#
# Resource Group
#

data "azurerm_resource_group" "sec_rg" {
  name = "${local.project}-sec-rg"
}

data "azurerm_resource_group" "azdo_rg" {
  name = "${local.product}-${var.location_short}-packer-azdoa-rg"
}

#
# Managed identity
#
data "azurerm_user_assigned_identity" "iac_federated_azdo" {
  for_each            = local.azdo_iac_managed_identities
  name                = each.key
  resource_group_name = local.azdo_managed_identity_rg_name
}
