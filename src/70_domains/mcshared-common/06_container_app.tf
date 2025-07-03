module "container_app_environment" {
  source = "./.terraform/modules/__v4__/container_app_environment"

  name                = "${local.project}-cae"
  location            = var.location
  resource_group_name = local.compute_rg_name

  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  subnet_id              = module.cae_env_snet.id
  internal_load_balancer = true
  zone_redundant         = true

  workload_profiles = [{
    name      = "Consumption"
    type      = "Consumption"
    min_count = 0
    max_count = 0
  }]

  private_endpoint_config = {
    enabled              = true
    subnet_id            = module.private_endpoint_cae_snet.id
    private_dns_zone_ids = [data.azurerm_private_dns_zone.container_app.id]
  }
  tags = module.tag_config.tags
}
