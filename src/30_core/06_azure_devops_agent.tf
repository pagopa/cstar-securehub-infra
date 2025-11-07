#
# Azure DevOps Agents APP
#
module "azdoa_linux_app" {
  source = "./.terraform/modules/__v4__/azure_devops_agent"
  count  = var.enable_azdoa ? 1 : 0

  name                      = "${local.project}-azdoa-ubuntu-app-vmss"
  resource_group_name       = data.azurerm_resource_group.azdo_rg.name
  subnet_id                 = data.azurerm_subnet.azdoa_snet.id
  subscription_id           = data.azurerm_subscription.current.subscription_id
  location                  = var.location
  image_type                = "custom" # enables usage of "source_image_name"
  image_resource_group_name = data.azurerm_resource_group.azdo_rg.name
  source_image_name         = "${local.product}-packer-azdo-agent-ubuntu2204-image-${var.azdo_agent_image_version}"
  vm_sku                    = "Standard_B2ms"

  zones        = var.devops_agent_zones
  zone_balance = var.devops_agent_balance_zones

  tags = module.tag_config.tags
}

#
# Azure DevOps Agents INFRA
#

module "azdoa_linux_infra" {
  source = "./.terraform/modules/__v4__/azure_devops_agent"
  count  = var.enable_azdoa ? 1 : 0

  name                      = "${local.project}-azdoa-ubuntu-infra-vmss"
  resource_group_name       = data.azurerm_resource_group.azdo_rg.name
  subnet_id                 = data.azurerm_subnet.azdoa_snet.id
  subscription_id           = data.azurerm_subscription.current.subscription_id
  location                  = var.location
  image_type                = "custom" # enables usage of "source_image_name"
  source_image_name         = "${local.product}-packer-azdo-agent-ubuntu2204-image-${var.azdo_agent_image_version}"
  image_resource_group_name = data.azurerm_resource_group.azdo_rg.name

  vm_sku = "Standard_B2ms"

  zones        = var.devops_agent_zones
  zone_balance = var.devops_agent_balance_zones

  tags = module.tag_config.tags
}

#
# Azure DevOps Agents Performance
#

module "azdoa_linux_perf" {
  source = "./.terraform/modules/__v4__/azure_devops_agent"
  count  = var.enable_azdoa ? 1 : 0

  name                      = "${local.project}-azdoa-ubuntu-perf-vmss"
  resource_group_name       = data.azurerm_resource_group.azdo_rg.name
  subnet_id                 = data.azurerm_subnet.azdoa_snet.id
  subscription_id           = data.azurerm_subscription.current.subscription_id
  location                  = var.location
  image_type                = "custom" # enables usage of "source_image_name"
  image_resource_group_name = data.azurerm_resource_group.azdo_rg.name
  source_image_name         = "${local.product}-packer-azdo-agent-ubuntu2204-image-${var.azdo_agent_image_version}"
  vm_sku                    = var.azdo_agent_perf_vm_sku

  zones        = var.devops_agent_zones
  zone_balance = var.devops_agent_balance_zones

  tags = module.tag_config.tags
}

#
# KV
#
resource "azurerm_key_vault_access_policy" "azdevops_iac_managed_identities_cicd" {
  for_each = local.azdo_iac_managed_identities

  key_vault_id = data.azurerm_key_vault.core_kvs["cicd"].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_user_assigned_identity.iac_federated_azdo[each.value].principal_id

  key_permissions         = ["Get", "List", "Decrypt", "Verify", "GetRotationPolicy"]
  secret_permissions      = ["Get", "List", "Set"]
  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get"]
  storage_permissions     = []
}

resource "azurerm_key_vault_access_policy" "azdevops_iac_managed_identities_core" {
  for_each = local.azdo_iac_managed_identities

  key_vault_id = data.azurerm_key_vault.core_kvs["core"].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_user_assigned_identity.iac_federated_azdo[each.value].principal_id

  key_permissions         = ["Get", "List", "Decrypt", "Verify", "GetRotationPolicy"]
  secret_permissions      = ["Get", "List", "Set", "Recover"]
  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get"]
  storage_permissions     = []
}
