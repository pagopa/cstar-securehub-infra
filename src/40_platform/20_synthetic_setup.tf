#
# synthetic
#
resource "azurerm_resource_group" "synthetic_rg" {
  name     = "${local.project}-synthetic-rg"
  location = var.location

  tags = module.tag_config.tags
}

resource "azurerm_log_analytics_workspace" "synthetic_log_analytics_workspace" {
  name                = "${local.project}-synthetic-law"
  location            = azurerm_resource_group.synthetic_rg.location
  resource_group_name = azurerm_resource_group.synthetic_rg.name
  tags                = module.tag_config.tags

  sku               = var.monitoring_law_sku
  retention_in_days = var.monitoring_law_retention_in_days
  daily_quota_gb    = var.monitoring_law_daily_quota_gb


  lifecycle {
    ignore_changes = [
      sku
    ]
  }
}

### 🔍 Application insights
resource "azurerm_application_insights" "synthetic_application_insights" {
  name                = "${local.project}-synthetic-appinsights"
  location            = azurerm_resource_group.synthetic_rg.location
  resource_group_name = azurerm_resource_group.synthetic_rg.name
  application_type    = "other"

  workspace_id = azurerm_log_analytics_workspace.synthetic_log_analytics_workspace.id

  tags = module.tag_config.tags
}

resource "azurerm_container_app_environment" "synthetic_cae" {
  name                = "${local.project}-synthetic-cae"
  location            = azurerm_resource_group.synthetic_rg.location
  resource_group_name = azurerm_resource_group.synthetic_rg.name
  tags                = module.tag_config.tags

  logs_destination           = "log-analytics"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.synthetic_log_analytics_workspace.id

  infrastructure_subnet_id       = module.synthetic_snet.id
  internal_load_balancer_enabled = true
  zone_redundancy_enabled        = true

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
    minimum_count         = 0
    maximum_count         = 0
  }

  depends_on = [
    module.synthetic_snet,
    azurerm_resource_group.synthetic_rg,
    azurerm_application_insights.synthetic_application_insights
  ]

  lifecycle {
    ignore_changes = [
      infrastructure_resource_group_name
    ]
  }
}

resource "azurerm_private_endpoint" "synthetic_cae_private_endpoint" {
  name                = azurerm_container_app_environment.synthetic_cae.name
  location            = azurerm_resource_group.synthetic_rg.location
  resource_group_name = azurerm_resource_group.synthetic_rg.name
  subnet_id           = module.container_app_private_endpoint_snet.id
  tags                = module.tag_config.tags

  private_service_connection {
    name                           = azurerm_container_app_environment.synthetic_cae.name
    private_connection_resource_id = azurerm_container_app_environment.synthetic_cae.id
    is_manual_connection           = false
    subresource_names              = ["managedEnvironments"]
  }

  private_dns_zone_group {
    name                 = data.azurerm_private_dns_zone.container_apps.name
    private_dns_zone_ids = [data.azurerm_private_dns_zone.container_apps.id]
  }

  depends_on = [
    azurerm_container_app_environment.synthetic_cae
  ]
}
