#
# Synthetic
#
module "synthetic_monitoring_jobs" {
  source = "./.terraform/modules/__v4__/monitoring_function"
  # source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//monitoring_function?ref=PAYMCLOUD-401-v-4-synthetic-aggiornamento-codice"

  location              = var.location
  location_display_name = var.location_display_name
  prefix                = "${local.product}-${var.location_short}"
  resource_group_name   = azurerm_resource_group.synthetic_rg.name

  enabled_sythetic_dashboard = false
  subscription_id            = data.azurerm_subscription.current.subscription_id

  application_insight_name    = azurerm_application_insights.synthetic_application_insights.name
  application_insight_rg_name = azurerm_application_insights.synthetic_application_insights.resource_group_name
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
    availability_prefix          = "synthetic"
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

  monitoring_configuration_encoded = jsonencode(local.endpoints_config_raw)

  depends_on = [
    module.synthetic_snet,
    azurerm_resource_group.synthetic_rg,
    azurerm_application_insights.monitoring_application_insights
  ]
}

locals {
  endpoints_config_raw = flatten([
    for file in fileset("${path.module}/synthetic_endpoints", "*.yaml.tpl") :
    yamldecode(templatefile("${path.module}/synthetic_endpoints/${file}", local.synthetic_variables))
  ])

  synthetic_variables = {
    tae_enabled    = var.synthetic_domain_tae_enabled
    idpay_enabled  = var.synthetic_domain_idpay_enabled
    shared_enabled = var.synthetic_domain_shared_enabled
    mc_enabled     = var.synthetic_domain_mc_enabled

    env_name                  = var.env,
    alert_enabled             = var.synthetic_alerts_enabled
    public_hostname           = local.public_hostname
    internal_private_hostname = local.internal_private_hostname
  }
}
