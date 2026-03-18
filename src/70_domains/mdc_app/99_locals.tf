locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}"

  tags = module.tag_config.tags

  # Default Domain Resource Group
  data_rg     = "${local.project}-data-rg"
  security_rg = "${local.project}-security-rg"
  compute_rg  = "${local.project}-compute-rg"
  cicd_rg     = "${local.project}-cicd-rg"
  monitor_rg  = "${local.project}-monitoring-rg"

  # 📊 Monitoring
  monitor_appinsights_name     = "${local.project}-appinsights"
  log_analytics_workspace_name = "${local.project}-law"

  #
  # AKS
  #
  aks_name                = "${local.product}-${var.location_short}-${var.env}-aks"
  aks_resource_group_name = "${local.product}-${var.location_short}-core-aks-rg"

  # 🔗 API Management
  apim_name    = "${local.product}-apim"
  apim_rg_name = "${local.product}-api-rg"

  # 🔒 Key Vault
  kv_domain_name    = "${local.project}-kv"
  kv_domain_rg_name = "${local.project}-security-rg"

  # 📥 Event Hub (data sources)
  eventhub_namespace_name    = "${local.project}-evh"
  eventhub_namespace_rg_name = "${local.project}-data-rg"

  ### ARGOCD
  argocd_internal_url = "argocd.${var.location_short}.${var.dns_zone_internal_prefix}.${var.external_domain}"

  # 🔔 Alerts
  # Base configuration shared across all alerts.
  # Modify here to change global behavior.
  base_alert_config = {
    evaluation_frequency         = "PT10M"
    window_duration              = "PT10M"
    severity                     = 1
    threshold                    = 0
    enabled                      = contains(["p"], var.env_short) ? true : false
    operator                     = "GreaterThan"
    time_aggregation_method      = "Count"
    minimum_failing_periods      = 1
    number_of_evaluation_periods = 1
    email_addresses = [
      "team_sw_client_msgcor-aaaanhfcws5qn5ndc4a4cjzm7m@pagopaspa.slack.com",
      "messaggidicortesia@assistenza.pagopa.it"
    ]
  }

  # MDC domain alerts map.
  # To add a new alert: add an entry here + the corresponding .kql file
  alerts_mdc = {
    retry_failures = {
      name        = "${local.project}-retry-failures-${var.env_short}"
      description = "Alert: Send of message failed after 3 retry. Environment: ${var.env}"
      query       = file("${path.module}/queries-KQL/retry_failures.kql")
    }
    api_5xx_errors = {
      name        = "${local.project}-5xx-errors-${var.env_short}"
      description = "Alert: Error 5XX on SEND API. Environment: ${var.env}"
      query       = file("${path.module}/queries-KQL/api_5xx_errors.kql")
    }
  }


  # Merge base config + alert-specific data.
  final_alerts = {
    for key, alert in local.alerts_mdc :
    key => merge(local.base_alert_config, alert)
  }
}
