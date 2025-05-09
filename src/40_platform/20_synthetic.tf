#
# synthetic
#
resource "azurerm_resource_group" "synthetic_rg" {
  name     = "${local.project}-synthetic-rg"
  location = var.location

  tags = var.tags
}

resource "azurerm_container_app_environment" "synthetic_cae" {
  name                = "${local.project}-synthetic-cae"
  location            = azurerm_resource_group.synthetic_rg.location
  resource_group_name = azurerm_resource_group.synthetic_rg.name

  log_analytics_workspace_id     = azurerm_log_analytics_workspace.monitoring_log_analytics_workspace.id
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
    azurerm_application_insights.monitoring_application_insights
  ]

  lifecycle {
    ignore_changes = [
      infrastructure_resource_group_name
    ]
  }
}

resource "azurerm_private_endpoint" "private_endpoint_container_app" {
  name                = azurerm_container_app_environment.synthetic_cae.name
  location            = azurerm_resource_group.synthetic_rg.location
  resource_group_name = azurerm_resource_group.synthetic_rg.name
  subnet_id           = module.container_app_private_endpoint_snet.id

  private_service_connection {
    name                           = azurerm_container_app_environment.synthetic_cae.name
    private_connection_resource_id = azurerm_container_app_environment.synthetic_cae.id
    is_manual_connection           = false
    subresource_names              = ["managedEnvironments"]
  }

  depends_on = [
    azurerm_container_app_environment.synthetic_cae
  ]
}


module "synthetic_monitoring_jobs" {
  source = "./.terraform/modules/__v4__/monitoring_function"

  location            = var.location
  prefix              = "${local.product}-${var.location_short}"
  resource_group_name = azurerm_resource_group.synthetic_rg.name

  enabled_sythetic_dashboard = true
  subscription_id            = data.azurerm_subscription.current.subscription_id
  grafana_api_key            = data.azurerm_key_vault_secret.grafana_dashboard_bot_api_key.value
  grafana_url                = azurerm_dashboard_grafana.grafana_dashboard.endpoint

  application_insight_name    = azurerm_application_insights.monitoring_application_insights.name
  application_insight_rg_name = azurerm_application_insights.monitoring_application_insights.resource_group_name
  application_insights_action_group_ids = flatten([
    [
      azurerm_monitor_action_group.cstar_status.id,
    ],
    (var.env == "prod" ? [
      azurerm_monitor_action_group.cstar_status.id,
      data.azurerm_monitor_action_group.infra_opsgenie[0].id
    ] : [])
  ])

  job_settings = {
    container_app_environment_id = azurerm_container_app_environment.synthetic_cae.id
  }

  storage_account_settings = {
    private_endpoint_enabled  = true
    table_private_dns_zone_id = data.azurerm_private_dns_zone.storage_account_table.id
    replication_type          = var.synthetic_storage_account_replication_type
  }

  storage_private_endpoint_subnet_id = module.storage_private_endpoint_snet.id

  tags = var.tags

  self_alert_configuration = {
    enabled = var.synthetic_self_alert_enabled
  }

  monitoring_configuration_encoded = templatefile("${path.module}/synthetic_endpoints/monitoring_configuration.json.tpl", {
    env_name                       = var.env,
    alert_enabled                  = var.synthetic_alerts_enabled
    public_domain_suffix           = local.public_domain_suffix
    internal_private_domain_suffix = local.internal_private_domain_suffix
  })
}
