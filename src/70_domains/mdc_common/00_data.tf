# 🔑 Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.product}-adgroup-admin"
}

data "azuread_group" "adgroup_developers" {
  display_name = "${local.product}-adgroup-developers"
}

data "azuread_group" "adgroup_externals" {
  display_name = "${local.product}-adgroup-externals"
}

data "azuread_group" "adgroup_domain_admin" {
  display_name = "${local.project_entra}-adgroup-admin"
}

data "azuread_group" "adgroup_domain_developers" {
  display_name = "${local.project_entra}-adgroup-developers"
}

data "azuread_group" "adgroup_domain_externals" {
  display_name = "${local.project_entra}-adgroup-externals"
}

data "azuread_group" "adgroup_domain_project_managers" {

  display_name = "${local.project_entra}-adgroup-project-managers"
}

data "azuread_group" "adgroup_domain_oncall" {
  count        = var.env == "prod" ? 1 : 0
  display_name = "${local.project_entra}-adgroup-oncall"
}

#
# Azure Resource Groups
#
data "azurerm_resource_group" "mdc_data_rg" {
  name = "${local.project}-data-rg"
}

# 🔒 KV
data "azurerm_key_vault" "kv_domain" {
  name                = local.kv_domain_name
  resource_group_name = local.kv_domain_rg_name
}

data "azurerm_key_vault_secret" "client_id_for_keycloak" {
  name         = "keycloak-terraform-admin-client-id"
  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

data "azurerm_key_vault_secret" "client_secret_for_keycloak" {
  name         = "keycloak-terraform-admin-client-secret"
  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

#
# Use this resource only during realm creation
#
# data "azurerm_key_vault_secret" "terraform_client_secret_for_keycloak" {
#   name         = "terraform-client-secret-for-keycloak"
#   key_vault_id = data.azurerm_key_vault.kv_domain.id
# }

data "azurerm_key_vault_secret" "keycloak_url" {
  name         = "keycloak-url"
  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

# client id and secret
data "azurerm_key_vault_secret" "send_client_id" {
  name         = "send-client-id"
  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

data "azurerm_key_vault_secret" "send_client_secret" {
  name         = "send-client-secret"
  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

data "azurerm_key_vault_secret" "emd_pagopa_client_id" {
  name         = "emd-pagopa-client-id"
  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

data "azurerm_key_vault_secret" "emd_pagopa_client_secret" {
  name         = "emd-pagopa-client-secret"
  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

data "azurerm_key_vault_secret" "emd_tpp_test_client_id" {
  name         = "emd-tpp-test-client-id"
  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

data "azurerm_key_vault_secret" "emd_tpp_test_client_secret" {
  name         = "emd-tpp-test-client-secret"
  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

# 🔎 DNS
data "azurerm_private_dns_zone" "internal" {
  name                = local.internal_dns_zone_name
  resource_group_name = local.internal_dns_zone_resource_group_name
}

data "azurerm_private_dns_zone" "cosmos" {
  name                = local.cosmos_dns_zone_name
  resource_group_name = local.cosmos_dns_zone_resource_group_name
}

data "azurerm_private_dns_zone" "eventhub" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = local.vnet_legacy_resource_group_name
}

data "azurerm_private_dns_zone" "privatelink_redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = local.vnet_legacy_resource_group_name
}

# 🐳 Kubernetes Cluster
data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = local.aks_resource_group_name
}

# NatGateway
data "azurerm_nat_gateway" "compute_nat_gateway" {
  name                = "${local.project_core}-compute-natgw"
  resource_group_name = local.vnet_network_rg
}

data "azurerm_api_management" "apim" {
  name                = local.apim_name
  resource_group_name = "${local.product}-api-rg"
}


data "azurerm_monitor_action_group" "slack" {
  resource_group_name = local.monitoring_core_rg_name
  name                = local.monitor_action_group_slack
}

data "azurerm_monitor_action_group" "email" {
  resource_group_name = local.monitoring_core_rg_name
  name                = local.monitor_action_group_email
}

# Azure Data Factory
data "azurerm_data_factory" "data_factory" {
  name                = local.data_factory_name
  resource_group_name = local.data_factory_rg_name
}

# cluster ADX
data "azurerm_kusto_cluster" "kusto_cluster" {
  name                = local.data_explorer_name
  resource_group_name = local.data_explorer_rg_name
}

