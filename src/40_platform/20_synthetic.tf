#
# Network
#
module "synthetic_snet" {
  # source = "./.terraform/modules/__v4__/subnet"
  source               = "git::https://github.com/pagopa/terraform-azurerm-v4.git//subnet?ref=synthetic-improvements"

  name                 = "${local.project}-synthetic-snet"
  resource_group_name  = data.azurerm_virtual_network.vnet_platform.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet_platform.name
  address_prefixes     = var.cidr_subnet_synthetic

  delegation = {
    name = "Microsoft.App/environments"
    service_delegation = {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"
      ]
    }
  }

}

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

  log_analytics_workspace_id = azurerm_log_analytics_workspace.monitoring_log_analytics_workspace.id
  infrastructure_subnet_id   = module.synthetic_snet.id
  internal_load_balancer_enabled = true
  zone_redundancy_enabled = true
  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
    minimum_count = 0
    maximum_count = 10
  }

  depends_on = [
    module.synthetic_snet
  ]
}

module "synthetic_monitoring_jobs" {
  source     = "./.terraform/modules/__v4__/monitoring_function"
  depends_on = [azurerm_application_insights.monitoring_application_insights]

  legacy = false

  location            = var.location
  prefix              = "${local.product}-${var.location_short}"
  resource_group_name = azurerm_resource_group.synthetic_rg.name

  application_insight_name              = azurerm_application_insights.monitoring_application_insights.name
  application_insight_rg_name           = azurerm_application_insights.monitoring_application_insights.resource_group_name
  # application_insights_action_group_ids = [data.azurerm_monitor_action_group.slack.id]

  docker_settings = {
    image_tag = "v1.10.0@sha256:1686c4a719dc1a3c270f98f527ebc34179764ddf53ee3089febcb26df7a2d71d"
  }

  job_settings = {
    cron_scheduling              = "*/5 * * * *"
    container_app_environment_id = azurerm_container_app_environment.synthetic_cae.id
    http_client_timeout          = 30000
  }

  storage_account_settings = {
    private_endpoint_enabled  = true
    table_private_dns_zone_id = data.azurerm_private_dns_zone.storage_account_table.id
    replication_type          = var.synthetic_storage_account_replication_type
  }

  private_endpoint_subnet_id = module.synthetic_snet.id

  tags = var.tags

  self_alert_configuration = {
    enabled = var.synthetic_self_alert_enabled
  }

  monitoring_configuration_encoded = templatefile("${path.module}/synthetic_endpoints/monitoring_configuration.json.tpl", {
    env_name               = var.env,
    alert_enabled          = var.synthetic_alerts_enabled
  })
}
