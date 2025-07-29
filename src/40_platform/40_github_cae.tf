module "github_container_app_environment" {
  source = "./.terraform/modules/__v4__/container_app_environment"

  name                = "${local.project}-github-cae"
  location            = var.location
  resource_group_name = module.default_resource_groups[var.domain].resource_group_names["compute"]

  subnet_id              = module.github_cae_snet.id
  internal_load_balancer = true
  zone_redundant         = var.env_short == "p" ? true : false

  workload_profiles = [{
    name      = "Consumption"
    type      = "Consumption"
    min_count = 0
    max_count = 0
  }]

  private_endpoint_config = {
    enabled              = true
    subnet_id            = module.container_app_private_endpoint_snet.id
    private_dns_zone_ids = [data.azurerm_private_dns_zone.container_apps.id]
  }

  tags = module.tag_config.tags
}

resource "azurerm_monitor_diagnostic_setting" "container_app_environment_diagnostic" {
  name                       = "${local.project}-github-cae-diagnostic"
  target_resource_id         = module.github_container_app_environment.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs_workspace.id

  enabled_log {
    category = "ContainerAppconsolelogs"

  }

  enabled_log {
    category = "ContainerAppsystemlogs"

  }
}
