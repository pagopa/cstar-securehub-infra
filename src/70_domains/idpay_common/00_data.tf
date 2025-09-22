data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

#
# Azure Resource Groups
#
data "azurerm_resource_group" "idpay_data_rg" {
  name = "${local.project}-data-rg"
}

data "azurerm_resource_group" "idpay_monitoring_rg" {
  name = "${local.project}-monitoring-rg"
}

#----------------------------------------------------------------
# 🌐 Network
#----------------------------------------------------------------
data "azurerm_virtual_network" "vnet_spoke_data" {
  name                = local.vnet_spoke_data_name
  resource_group_name = local.vnet_spoke_data_rg_name
}

data "azurerm_dns_zone" "public_cstar" {
  name                = local.public_dns_zone_name
  resource_group_name = local.vnet_core_rg_name
}

data "azurerm_nat_gateway" "compute_nat_gateway" {
  name                = "${local.project_core}-compute-natgw"
  resource_group_name = local.network_rg
}

data "azurerm_dns_zone" "bonus_elettrodomestici_apex" {
  for_each            = toset(local.public_dns_zone_bonus_elettrodomestici.zones)
  name                = each.value
  resource_group_name = "${local.project_core}-network-rg"
}

#
# Private DNS Zones
#
# Cosmos MongoDB private dns zone
data "azurerm_private_dns_zone" "cosmos_mongo" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = local.vnet_core_rg_name
}

# Eventhub private dns zone
data "azurerm_private_dns_zone" "eventhub" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = local.vnet_core_rg_name
}

# Redis private dns zone
data "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = local.vnet_core_rg_name
}

data "azurerm_private_dns_zone" "servicebus" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = local.vnet_core_rg_name
}

data "azurerm_private_dns_zone" "blob_storage" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = local.vnet_core_rg_name
}

data "azurerm_private_dns_zone" "storage_account_table" {
  name                = "privatelink.table.core.windows.net"
  resource_group_name = local.vnet_core_rg_name
}

#
# KeyVault
#
data "azurerm_key_vault" "domain_kv" {
  name                = local.idpay_kv_name
  resource_group_name = local.idpay_kv_rg_name
}
# CORE
data "azurerm_key_vault" "core_kv" {
  name                = local.kv_core_name
  resource_group_name = local.kv_core_resource_group_name
}

### ARGO
data "azurerm_key_vault_secret" "argocd_admin_username" {
  name         = "argocd-admin-username"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

data "azurerm_key_vault_secret" "argocd_admin_password" {
  name         = "argocd-admin-password"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

#
# Azure Kubernetes Service
#
data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = local.aks_resource_group_name
}

#
# Azure Monitor
#
data "azurerm_log_analytics_workspace" "core_log_analytics" {
  name                = local.core_log_analytics_workspace_name
  resource_group_name = local.core_monitor_resource_group_name
}

data "azurerm_resource_group" "core_monitor_rg" {
  name = local.core_monitor_resource_group_name
}

data "azurerm_application_insights" "core_application_insights" {
  name                = local.core_application_insights_name
  resource_group_name = data.azurerm_resource_group.core_monitor_rg.name
}

data "azurerm_resource_group" "apim_rg" {
  name = local.apim_rg_name
}

data "azurerm_api_management" "apim_core" {
  name                = local.apim_name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
}

#
# KV Secrets
#
data "azurerm_key_vault_secret" "terraform_client_secret_for_keycloak" {
  name         = "terraform-client-secret-for-keycloak"
  key_vault_id = data.azurerm_key_vault.core_kv.id
}

data "azurerm_key_vault_secret" "keycloak_url" {
  name         = "keycloak-url"
  key_vault_id = data.azurerm_key_vault.core_kv.id
}

data "azurerm_key_vault_secret" "ses_smtp_username" {
  name         = "aws-ses-mail-smtp-username"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

data "azurerm_key_vault_secret" "ses_smtp_password" {
  name         = "aws-ses-mail-smtp-password"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

data "azurerm_key_vault_secret" "ses_smtp_host" {
  name         = "aws-ses-mail-host"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

data "azurerm_key_vault_secret" "ses_from_address" {
  name         = "aws-ses-mail-from"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

data "azurerm_key_vault_certificate" "bonus_elettrodomestici_cert_apex" {
  for_each = toset([
    for zone in local.public_dns_zone_bonus_elettrodomestici.zones :
    join("-", split(".", zone))
  ])

  key_vault_id = data.azurerm_key_vault.domain_kv.id
  name         = each.value
}

data "azurerm_key_vault_secret" "oneidentity-client-id" {
  name         = "oneidentity-client-id"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

data "azurerm_key_vault_secret" "oneidentity-client-secret" {
  name         = "oneidentity-client-secret"
  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

# APIM
#

data "azurerm_api_management" "apim" {
  name                = local.apim_name
  resource_group_name = local.apim_rg_name
}

#
# AZDO
#
data "azurerm_user_assigned_identity" "iac_federated_azdo" {
  for_each = toset(concat(local.azdo_iac_managed_identities_read, local.azdo_iac_managed_identities_write))

  name                = each.key
  resource_group_name = local.azdo_managed_identity_rg_name
}
