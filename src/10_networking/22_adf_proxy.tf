# resource "azurerm_resource_group" "adx_proxy" {
#   name     = "${var.prefix}-${var.env_short}-adx-egress-proxy-rg"
#   location = var.location
# }

module "adf_proxy" {
  source = "./.terraform/modules/__v4__/IDH/adf_egress_proxy"

  database_adf_proxy_mapping = [
    {
      fqdn             = "idpay-db.${var.env_short}.internal.postgresql.cstar.pagopa.it"
      external_port    = 5432
      destination_port = 5432
    }
  ]

  env = var.env
  idh_resource_tier = "small"
  name = "${var.prefix}-${var.env_short}-adf-proxy"
  product_name = var.prefix
  subscription_id = data.azurerm_subscription.current.subscription_id
  tags = module.tag_config.tags
  vmss_credentials = {
    admin_login = data.azurerm_key_vault_secret.network_vmss_login.value
    admin_password = data.azurerm_key_vault_secret.network_vmss_password.value
  }



  vmss_resource_group_name = azurerm_resource_group.rg_network.name # azurerm_resource_group.adx_proxy.name
  vnet = {
    name = module.vnet_core_hub.name
    resource_group_name = module.vnet_core_hub.resource_group_name
  }
  # nat_gateway = {
  #   resource_group_name = azurerm_nat_gateway.compute_nat_gateway.resource_group_name
  #   name = azurerm_nat_gateway.compute_nat_gateway.name
  # }

  output_kv = {
    name                = local.kv_core_name
    resource_group_name = local.kv_core_resource_group_name
  }



}


# devo crare il dns internal per i postgres, la gui adx non fa creare gli hostname altrimenti