module "azdoa_linux_app" {
  source = "./.terraform/modules/__v3__/azure_devops_agent"
  count  = var.enable_azdoa ? 1 : 0

  name                = "${local.project}-azdoa-vmss-ubuntu-app"
  resource_group_name = data.azurerm_resource_group.packer_rg.name
  subnet_id           = data.azurerm_subnet.azdoa_snet.id
  subscription_id     = data.azurerm_subscription.current.subscription_id
  location            = var.location
  image_type          = "custom" # enables usage of "source_image_name"
  source_image_name   = "${local.product}-${var.location_short}-packer-azdo-agent-ubuntu2204-image-${var.azdo_agent_image_version}"
  vm_sku              = "Standard_B2ms"

  zones        = var.devops_agent_zones
  zone_balance = var.devops_agent_balance_zones

  tags = var.tags
}

module "azdoa_linux_infra" {
  source = "./.terraform/modules/__v3__/azure_devops_agent"
  count  = var.enable_azdoa ? 1 : 0

  name                = "${local.project}-azdoa-vmss-ubuntu-infra"
  resource_group_name = data.azurerm_resource_group.packer_rg.name
  subnet_id           = data.azurerm_subnet.azdoa_snet.id
  #   subscription_name   = data.azurerm_subscription.current.display_name
  subscription_id   = data.azurerm_subscription.current.subscription_id
  location          = var.location
  image_type        = "custom" # enables usage of "source_image_name"
  source_image_name = "${local.product}-${var.location_short}-packer-azdo-agent-ubuntu2204-image-${var.azdo_agent_image_version}"
  vm_sku            = "Standard_B2ms"

  zones        = var.devops_agent_zones
  zone_balance = var.devops_agent_balance_zones

  tags = var.tags
}

#
# KV
#
resource "azurerm_key_vault_access_policy" "azdevops_iac_managed_identities" {
  for_each = local.azdo_iac_managed_identities

  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_user_assigned_identity.iac_federated_azdo[each.key].principal_id

  key_permissions    = ["Get", "List", "Decrypt", "Verify", "GetRotationPolicy"]
  secret_permissions = ["Get", "List", "Set", ]

  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get"]

  storage_permissions = []
}
