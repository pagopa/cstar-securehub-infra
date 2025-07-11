resource "azurerm_container_app_environment" "srtp_cae" {
  name                = "${local.project}-cae"
  location            = data.azurerm_resource_group.compute_rg.location
  resource_group_name = data.azurerm_resource_group.compute_rg.name
  tags                = module.tag_config.tags

  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
  logs_destination           = "log-analytics"

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

  private_dns_zone_group {
    name                 = data.azurerm_private_dns_zone.container_apps.name
    private_dns_zone_ids = [data.azurerm_private_dns_zone.container_apps.id]
  }

  depends_on = [
    azurerm_container_app_environment.srtp_cae
  ]
}

resource "azurerm_container_app_environment_storage" "rtp_sender_file_share_storage" {
  name                         = "${local.project}-sender-fss"
  container_app_environment_id = azurerm_container_app_environment.srtp_cae.id
  account_name                 = module.share_storage_account.name
  share_name                   = azurerm_storage_share.rtp_jks_file_share.name
  access_key                   = module.share_storage_account.primary_access_key
  access_mode                  = "ReadWrite"
}
