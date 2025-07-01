resource "azurerm_container_app_environment" "srtp_cae" {
  name                = "${local.project}-cae"
  location            = data.azurerm_resource_group.compute_rg.location
  resource_group_name = data.azurerm_resource_group.compute_rg.name

  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log_analytics_workspace.id
  infrastructure_subnet_id       = module.cae_env_snet.id
  internal_load_balancer_enabled = true
  zone_redundancy_enabled        = true
  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
    minimum_count         = 0
    maximum_count         = 0
  }

  lifecycle {
    ignore_changes = [
      infrastructure_resource_group_name
    ]
  }
}

resource "azurerm_management_lock" "cae_lock" {
  count = var.env != "prod" ? 1 : 0

  name       = "${azurerm_container_app_environment.srtp_cae.name}-lock"
  scope      = azurerm_container_app_environment.srtp_cae.id
  lock_level = "CanNotDelete"
}

resource "azurerm_private_endpoint" "srtp_cae_private_endpoint" {
  name                = azurerm_container_app_environment.srtp_cae.name
  location            = data.azurerm_resource_group.compute_rg.location
  resource_group_name = data.azurerm_resource_group.compute_rg.name
  subnet_id           = azurerm_subnet.private_endpoint_cae_env_snet.id

  private_service_connection {
    name                           = azurerm_container_app_environment.srtp_cae.name
    private_connection_resource_id = azurerm_container_app_environment.srtp_cae.id
    is_manual_connection           = false
    subresource_names              = ["managedEnvironments"]
  }

  depends_on = [
    azurerm_container_app_environment.srtp_cae
  ]
}
