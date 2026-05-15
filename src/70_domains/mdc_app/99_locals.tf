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
  alert_email_secret_names = var.env_short == "p" ? ["email-mdc-slack", "email-mdc-google"] : []
  alert_email_addresses    = [for k, v in module.secrets.values : v.value if contains(local.alert_email_secret_names, k)]

  # Base configuration shared across all alerts.
  # Modify here to change global behavior.
  base_alert_config = {
    evaluation_frequency = 10
    window_duration      = 10
    severity             = 1
    threshold            = 0
    enabled              = true
    operator             = "GreaterThan"
    email_addresses      = local.alert_email_addresses
  }

  # MDC domain alerts map.
  # To add a new alert: add an entry here + the corresponding .kql file
  alerts_mdc = {
    retry_failures = {
      name          = "${local.project}-retry-failures-${var.env_short}"
      email_subject = "Alert: Send of message failed after 3 retry. Environment: ${var.env}"
      query         = file("${path.module}/queries-KQL/retry_failures.kql")
    }
    api_5xx_errors = {
      name          = "${local.project}-5xx-errors-${var.env_short}"
      email_subject = "Alert: Error 5XX on SEND API. Environment: ${var.env}"
      query         = file("${path.module}/queries-KQL/api_5xx_errors.kql")
    }
  }

  # Alert active only on UAT (subset of alerts_mdc)
  alerts_uat = {
    api_5xx_errors = local.alerts_mdc.api_5xx_errors
  }

  # Merge base config + alert-specific data.
  final_alerts = {
    for key, alert in(
      var.env_short == "p" ? local.alerts_mdc :
      var.env_short == "u" ? local.alerts_uat :
      {}
    ) :
    key => merge(local.base_alert_config, alert)
  }
}
